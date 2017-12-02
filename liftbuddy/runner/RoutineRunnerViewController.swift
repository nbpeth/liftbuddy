import UIKit
import Foundation

class RoutineRunnerViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var workoutListTableView: UITableView!
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var nextLiftButton: UIButton!
    
    var routineInProgress:RoutineInProgress?
    var runner: RoutineRunner?
    var restTime = 0
    
    @IBAction func nextLiftButton(_ sender: Any) {
        guard let runner = runner,
            let restViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestViewController") as? RestViewController
        else { return }
        
        //confusing mechanics
        restViewController.restTime = runner.restTimeForCurrentWorkout()
        restViewController.modalPresentationStyle = .overCurrentContext
        
        runner.nextLiftSet()
        
        restViewController.nextLift = runner.currentLift
        
        if !runner.isOnLastLiftOfLastWorkout() {
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
        guard let routine = routineInProgress?.routine else { return }
        
        runner = RoutineRunner(routine: routine)
        workoutListTableView.delegate = self
        workoutListTableView.dataSource = self
        
        setLabels()
        
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
            let routine = routineInProgress?.routine
        else { return WorkoutInRunnerTableViewCell() }
        
        cell.workoutNameLabel.text = routine.workout[indexPath.row].name
        
        return cell
    }
    
    //            let focusedCell = self.workoutListTableView.cellForRow(at: IndexPath(row: runner.position.workoutIndex, section: 0)) as? WorkoutInRunnerTableViewCell

    
    private func setLabels(){
        
        guard let currentLift = runner?.currentLift,
            let weight = currentLift.weight.value,
            let reps = currentLift.reps.value
        else {
            return
        }
        
        workoutNameLabel.text = currentLift.name
        weightLabel.text = "Weight: \(String(describing:weight)) lbs"
        repsLabel.text = "Reps: \(String(describing:reps))"
        
    }
    
    private func focusCurrentWorkoutInTable(){
        guard let runner = runner else { return }
        
        if(!runner.isOnFirstWorkout() ) {
            let indexPath = IndexPath(row: runner.position.workoutIndex - 1 , section: 0)
            scrollTableToIndex(indexPath)
        }
    }
    
    private func scrollTableToIndex(_ IndexPath:IndexPath){
        workoutListTableView.scrollToRow(at: IndexPath, at: .top, animated: true)
    }
    
}
