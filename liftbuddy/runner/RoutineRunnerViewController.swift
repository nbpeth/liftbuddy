import UIKit
import Foundation

class RoutineRunnerViewController:BaseViewController, UITableViewDelegate, UITableViewDataSource, LiftRefresher {
    @IBOutlet weak var workoutListTableView: UITableView!
    @IBOutlet weak var nextLiftButton: UIBarButtonItem!
    @IBOutlet weak var restTimerLabel: UILabel!
    @IBOutlet weak var hudView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    var timer:RestTimer!
    var routine:RoutineInProgress?
    var runner: RoutineRunner?
    var restTime = 0
    
    @IBAction func nextLiftButtonWasPressed(_ sender: Any) {
        guard let runner = runner
            else { return }
        
        resetTimer()
        
        if runner.isOnLastLiftOfLastWorkout() {
            runner.completeLift()
            nextLiftButton.isEnabled = false
        }
            
        else {
            runner.nextLiftSet()
            focusCurrentWorkoutInTable()
            fireRestTimer()
        }
        
        self.workoutListTableView.reloadData()
    }
    
    private func resetTimer(){
        timer?.stop()
        restTimerLabel.text = "∞"
    }
    
    private func fireRestTimer(){
        guard let runner = runner, let workout = runner.currentWorkout, let rest = workout.rest.value else {
            return
        }
        
        restTime = rest
        restTimerLabel.text = String(describing: restTime)
        timer = RestTimer(labelToUpdate:self.restTimerLabel, rest: restTime )
        
        timer.fireRestTimer()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let runner = self.runner else { return }
        
        runner.changeWorkoutPosition(to: indexPath.section, liftIndex: indexPath.row)
        
        focusCurrentWorkoutInTable()
        self.workoutListTableView.reloadData()
    }
   
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let routine = self.routine else { return "" }
        return routine.workout[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let routine = self.routine else { return 0 }
        
        return routine.workout[section].lifts.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let routine = self.routine else { return 0 }
        return routine.workout.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "workoutInRunnerTableViewCell", for: indexPath) as? WorkoutInRunnerTableViewCell,
            let runner = runner,
            let routine = runner.routine
        else { return WorkoutInRunnerTableViewCell() }
    
        let workout = routine.workout[indexPath.section]
        cell.workout = workout
        cell.delegate = self
        
        if workout.lifts.count > indexPath.row {
            configureLift(cell: cell, workout: workout, indexPath: indexPath)
        }
        else{
            configureWorkoutEditing(cell: cell)
        }
        
        return cell
    }
    
    func configureWorkoutEditing(cell:WorkoutInRunnerTableViewCell){
        cell.backgroundColor = Theme.tabBarColor
        cell.coolXLabel.isHidden = true
        cell.setNumberLabel.isHidden = true
        cell.repsTextField.isHidden = true
        cell.weightTextField.isHidden = true
        cell.doneIndicator.isHidden = true
        
        cell.addSetButton.isHidden = false
    }
    
    func configureLift(cell:WorkoutInRunnerTableViewCell, workout:WorkoutInProgress, indexPath:IndexPath){
        let liftForRow = workout.lifts[indexPath.row]
        
        cell.setNumberLabel.isHidden = false
        cell.repsTextField.isHidden = false
        cell.weightTextField.isHidden = false
        cell.doneIndicator.isHidden = false
        cell.coolXLabel.isHidden = false
        cell.addSetButton.isHidden = true
        
        cell.backgroundColor = Theme.tabBarColor
        cell.setNumberLabel.text = "\(String(describing: indexPath.row + 1))."
        cell.repsTextField.text = String(describing: liftForRow.reps.value ?? 0)
        cell.weightTextField.text = String(describing: liftForRow.weight.value ?? 0.0)
        cell.lift = liftForRow
        cell.setDoneIndicatorColor()
        
        if runner?.position.workoutIndex == indexPath.section && runner?.position.liftIndex == indexPath.row {
            cell.backgroundColor = Theme.activeCellColor
        }
        else{
            cell.backgroundColor = Theme.inactiveCellColor
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let routine = routine else { return }
        
        runner = RoutineRunner(routine: routine)
        workoutListTableView.delegate = self
        workoutListTableView.dataSource = self
        startElapsedTimer()
        setupTheme()
    }
    
    private func startElapsedTimer(){
        IncrementingTimer.shared.start(labelToUpdate: elapsedTimeLabel)
    }
    
    private func setupTheme(){
        hudView.backgroundColor = Theme.foregroundColor
        workoutListTableView.backgroundColor = Theme.backgroundColor
        restTimerLabel.textColor = Theme.brightTextColor
        toolbar.barTintColor = Theme.tabBarColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "endRoutineSegue" {
            if let destination = segue.destination as? CompletedRoutineViewController {
                destination.routineInProgress = routine
            }
        }
    }
    
    private func focusCurrentWorkoutInTable(){
        guard let runner = runner else { return }
        let indexPath = IndexPath(row: runner.position.liftIndex, section: runner.position.workoutIndex)

        if(!runner.isOnLastLiftOfLastWorkout() ) {
            nextLiftButton.isEnabled = true
        }
        
        if workoutHasLifts(row: indexPath.section) {
            scrollTableToIndex(indexPath)
        }
    }
    
    private func workoutHasLifts(row:Int) -> Bool {
        guard let routine = routine else { return false }
        return routine.workout[row].lifts.count > 0
    }
    
    private func scrollTableToIndex(_ IndexPath:IndexPath){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.workoutListTableView.scrollToRow(at: IndexPath, at: .bottom, animated: true)
        }
    }
    
    func reload(){
        self.workoutListTableView.reloadData()
    }
}
