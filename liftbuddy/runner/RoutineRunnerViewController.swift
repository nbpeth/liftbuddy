import UIKit
import Foundation

class RoutineRunnerViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var workoutListTableView: UITableView!
    var routineInProgress:RoutineInProgress?
    var runner: RoutineRunner?
    var timer:Timer!
    var restTime = 0
    
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
    
    @IBAction func nextLiftButton(_ sender: Any) {
        
        guard let runner = runner,
            let routine = runner.routine,
            let workout = runner.currentWorkout,
            let nextLift = runner.nextLiftSet(),
            let weight = nextLift.weight.value,
            let reps = nextLift.reps.value
        else {
            return
        }
        
        fireRestTimer()
        
        focusCurrentWorkoutInTable()
        
        liftDataLabel.text = ":: \(nextLift.name), set: \(runner.liftIndex), reps: \(reps), weight: \(weight)"

    }
   
    private func focusCurrentWorkoutInTable(){
        guard let runner = runner else { return }
        
        if(runner.numberOfWorkoutsInRoutine() >= runner.workoutIndex ) {
            let indexPath = IndexPath(row: runner.workoutIndex - 1 , section: 0)
            workoutListTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        
    }
    
    @objc private func updateRestTimer() {
        nameLabel.text = String(describing: restTime )

        if restTime > 0 {
            restTime -= 1
        }
        else{
            timer.invalidate()
            nameLabel.text = String(describing: restTime )

        }
    }
    
    func fireRestTimer(){
        restTime = runner?.restTimeForCurrentWorkout() ?? 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateRestTimer), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let routine = routineInProgress?.routine else { return }
        runner = RoutineRunner(routine: routine)
        
        workoutListTableView.delegate = self
        workoutListTableView.dataSource = self
        
    }
    
}
