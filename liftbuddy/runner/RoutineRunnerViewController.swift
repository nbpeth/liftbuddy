import UIKit
import Foundation

class RoutineRunnerViewController:BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var workoutListTableView: UITableView!
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var nextLiftButton: UIButton!
    
    var routine:RoutineInProgress?
    var runner: RoutineRunner?
    var restTime = 0
    
    @IBAction func nextLiftButton(_ sender: Any) {
        guard let runner = runner,
            let restViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestViewController") as? RestViewController
        else { return }
        
        if !runner.isOnLastLiftOfLastWorkout() {
            runner.nextLiftSet()
            
            restViewController.restTime = runner.restTimeForCurrentWorkout()
            restViewController.modalPresentationStyle = .overCurrentContext
            restViewController.nextLift = runner.currentLift
            
            present(restViewController, animated: true, completion: nil)
        }
        else {
            workoutNameLabel.text = "ALL DONE"
            nextLiftButton.isEnabled = false
        }
        
        focusCurrentWorkoutInTable()
        setLabels()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        scrollTableToIndex(indexPath)
        
        nextLiftButton.isEnabled = true
        runner?.changeWorkoutPosition(to: indexPath.row)
        
        setLabels()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let runner = runner else { return 0 }
        return runner.numberOfWorkoutsInRoutine()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "workoutInRunnerTableViewCell", for: indexPath) as? WorkoutInRunnerTableViewCell,
            let routine = routine
        else { return WorkoutInRunnerTableViewCell() }
        
        cell.workoutNameLabel.text = routine.workout[indexPath.row].name
        
        return cell
    }
    
    private func setLabels(){
        workoutNameLabel.text = runner?.currentLift?.name ?? ""
        weightLabel.text = "Weight: \(String(describing:runner?.currentLift?.weight.value ?? 0 )) lbs"
        repsLabel.text = "Reps: \(String(describing:runner?.currentLift?.reps.value ?? 0 ))"
        
        workoutNameLabel.textColor = Theme.headerTextColor
        weightLabel.textColor = Theme.textColor
        repsLabel.textColor = Theme.textColor
    
    }
    
    private func focusCurrentWorkoutInTable(){
        guard let runner = runner else { return }
        
        if(!runner.isOnLastLiftOfLastWorkout() ) {
            let indexPath = IndexPath(row: runner.position.workoutIndex, section: 0)
            scrollTableToIndex(indexPath)
        }
    }
    
    private func scrollTableToIndex(_ IndexPath:IndexPath){
        workoutListTableView.scrollToRow(at: IndexPath, at: .top, animated: true)
    }
    
}
