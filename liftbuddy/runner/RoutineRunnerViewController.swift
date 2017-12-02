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
        focusCurrentWorkoutInTable()
        setLabels()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showRestModelSegue"){
            guard let destination = segue.destination as? RestViewController, let runner = runner else { return }
            destination.restTime = runner.restTimeForCurrentWorkout()
        }
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
        guard let currentLift = runner?.nextLiftSet(),
            let weight = currentLift.weight.value,
            let reps = currentLift.reps.value
        else {
            workoutNameLabel.text = "ALL DONE"

            nextLiftButton.isEnabled = false
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
