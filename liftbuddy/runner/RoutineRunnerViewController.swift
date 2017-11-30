import UIKit
import Foundation

class RoutineRunnerViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var workoutListTableView: UITableView!
    var routineInProgress:RoutineInProgress?
    var runner: RoutineRunner?
    
    @IBOutlet weak var liftDataLabel: UILabel!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let runner = runner else { return 0 }
        return runner.numberOfWorkoutsInRoutine()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "workoutInRunnerTableViewCell", for: indexPath) as? WorkoutInRunnerTableViewCell,
            let routine = routineInProgress?.routine else { return UITableViewCell() }
        
        cell.workoutNameLabel.text = routine.workout[indexPath.row].name
        
        return cell
    }
    
    private func focusCurrentWorkoutInTable(){
        guard let runner = runner else { return }
        
        if(runner.numberOfWorkoutsInRoutine() > runner.workoutIndex ) {
            
            let indexPath = IndexPath(row: runner.workoutIndex, section: 0)
            workoutListTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
     
    }
    
    @IBAction func nextLiftButton(_ sender: Any) {
        focusCurrentWorkoutInTable()
    
        nameLabel.text = runner?.currentWorkout?.name ?? "nope"
        
        guard let runner = runner,
            let next = runner.nextLiftSet(),
            let weight = next.weight.value,
            let reps = next.reps.value
            else {
                liftDataLabel.text = " -- "
                return
                
        }

        liftDataLabel.text = "set: \(runner.liftIndex), reps: \(reps), weight: \(weight)"

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let routine = routineInProgress?.routine else { return }
        runner = RoutineRunner(routine: routine)
        
        workoutListTableView.delegate = self
        workoutListTableView.dataSource = self

        
        guard let runner = runner,
            let next = runner.nextLiftSet(),
            let weight = next.weight.value,
            let reps = next.reps.value
            else {
                liftDataLabel.text = " -- "
                return
                
        }
        nameLabel.text = runner.currentWorkout?.name ?? "nothing here"

        liftDataLabel.text = "set: \(runner.liftIndex), reps: \(reps), weight: \(weight)"
        
    }
    
}
