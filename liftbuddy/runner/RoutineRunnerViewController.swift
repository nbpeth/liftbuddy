import UIKit
import Foundation

class RoutineRunnerViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var workoutListTableView: UITableView!
    @IBOutlet weak var liftDataLabel: UILabel!

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
        
        nameLabel.text = ""
        
        runner?.changeWorkoutPosition(to: indexPath.row)
        
        setLabels()
        
    }
    
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
    
    private func setLabels(){
        guard let runner = runner,
            let nextLift = runner.nextLiftSet(),
            let weight = nextLift.weight.value,
            let reps = nextLift.reps.value
        else {
            return
        }
        
        liftDataLabel.text = ":: \(nextLift.name), set: \(runner.position.liftIndex), reps: \(reps), weight: \(weight)"
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
