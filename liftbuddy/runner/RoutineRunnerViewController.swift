import UIKit
import Foundation

class RoutineRunnerViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var workoutListTableView: UITableView!
    @IBOutlet weak var liftDataLabel: UILabel!

    var routineInProgress:RoutineInProgress?
    var runner: RoutineRunner?
    var timer:RestTimer!
    var restTime = 0
    
    @IBAction func nextLiftButton(_ sender: Any) {
        
        guard let runner = runner else { return }
        timer?.stop()
        timer = RestTimer(delegate:self, rest: runner.restTimeForCurrentWorkout() )
        timer.fireRestTimer()
        
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
        
        timer?.stop()
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
        
        liftDataLabel.text = ":: \(nextLift.name), set: \(runner.liftIndex), reps: \(reps), weight: \(weight)"
    }
    
    private func focusCurrentWorkoutInTable(){
        guard let runner = runner else { return }
        
        if(runner.numberOfWorkoutsInRoutine() >= runner.workoutIndex && runner.workoutIndex > 0 ) {
            let indexPath = IndexPath(row: runner.workoutIndex - 1 , section: 0)
            scrollTableToIndex(indexPath)
        }
    }
    
    private func scrollTableToIndex(_ IndexPath:IndexPath){
        workoutListTableView.scrollToRow(at: IndexPath, at: .top, animated: true)
    }
    
}

class RestTimer {
    var timer:Timer!
    var restTime = 0
    var delegate:UIViewController!
    
    init(delegate:UIViewController, rest:Int){
        self.delegate = delegate
        self.restTime = rest
    }
    
    @objc private func updateRestTimer() {
        guard let delegate = delegate as? RoutineRunnerViewController else { return }
        
        delegate.nameLabel.text = String(describing: restTime )
        
        if restTime > 0 {
            restTime -= 1
        }
        else{
            timer.invalidate()
            delegate.nameLabel.text = String(describing: restTime )
        }
    }
    
    func fireRestTimer(){
        guard let delegate = delegate as? RoutineRunnerViewController else { return }

        restTime = delegate.runner?.restTimeForCurrentWorkout() ?? 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateRestTimer), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    func stop(){
        timer?.invalidate()
    }
}
