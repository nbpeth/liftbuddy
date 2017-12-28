import UIKit
import Foundation

class RoutineRunnerViewController:BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var workoutListTableView: UITableView!
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var nextLiftButton: UIBarButtonItem!
    @IBOutlet weak var restTimerLabel: UILabel!
    var timer:RestTimer!
    var routine:RoutineInProgress?
    var runner: RoutineRunner?
    var restTime = 0
    
    @IBAction func nextLiftButtonWasPressed(_ sender: Any) {
        guard let runner = runner
            else { return }
        
        if runner.isOnLastLiftOfLastWorkout() {
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
        timer = RestTimer(delegate:self, rest: restTime )
        
        timer.fireRestTimer()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let runner = self.runner else { return }
        
        runner.changeWorkoutPosition(to: indexPath.section, liftIndex: indexPath.row)
        
        focusCurrentWorkoutInTable()
        self.workoutListTableView.reloadData()
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let routine = self.routine else { return 0 }
        
        return routine.workout[section].lifts.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let routine = self.routine else { return "" }
        return routine.workout[section].name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let routine = self.routine else { return 0 }
        return routine.workout.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "workoutInRunnerTableViewCell", for: indexPath) as? WorkoutInRunnerTableViewCell,
            let routine = routine
        else { return WorkoutInRunnerTableViewCell() }
        
        cell.workoutNameLabel.text = routine.workout[indexPath.section].name
        
        if runner?.position.workoutIndex == indexPath.section && runner?.position.liftIndex == indexPath.row {
            cell.backgroundColor = Theme.cellSelectedBackgroundColor
            
        }
        else{
            cell.backgroundColor = Theme.cellAlternateBackgroundColor
        }
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let routine = routine else { return }
        
        runner = RoutineRunner(routine: routine)
        workoutListTableView.delegate = self
        workoutListTableView.dataSource = self
        
        setLabels()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "endRoutineSegue" {
            if let destination = segue.destination as? CompletedRoutineViewController {
                destination.routineInProgress = routine
            }
        }
    }
    
    private func setLabels(){
        
    }
    
    private func focusCurrentWorkoutInTable(){
        guard let runner = runner else { return }
        
        if(!runner.isOnLastLiftOfLastWorkout() ) {
            nextLiftButton.isEnabled = true
            resetTimer()
            let indexPath = IndexPath(row: runner.position.liftIndex, section: runner.position.workoutIndex)
            scrollTableToIndex(indexPath)
        }
    }
    
    private func scrollTableToIndex(_ IndexPath:IndexPath){
        workoutListTableView.scrollToRow(at: IndexPath, at: .top, animated: true)
    }
}

//    private func configueViews(){
//        self.workoutListTableView.layer.shadowColor = UIColor.black.cgColor
//        self.workoutListTableView.layer.shadowOpacity = 1
//        self.workoutListTableView.layer.shadowRadius = 10
//        self.workoutListTableView.layer.shadowOffset = CGSize.zero
//        self.workoutListTableView.layer.shadowPath = UIBezierPath(rect: self.workoutListTableView.bounds).cgPath
//    }
