import Foundation
import UIKit

class CreateRoutineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var routine: Routine?

    @IBOutlet weak var routineTableView: UITableView!
    @IBOutlet weak var routineNameLabel: UILabel!
    
    @IBAction func addWorkoutButtonWasPressed(_ sender: Any) {
        let newWorkout = Workout()
        routine?.workout.append(newWorkout)
        
        self.routineTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfWorkouts = routine?.workout.count else { return 0 }
        
        return numberOfWorkouts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as? WorkoutCell,
            let count = routine?.workout[indexPath.row].lifts.count else { return UITableViewCell() }

        cell.numberOfSetsLabel.text = "Sets: \(String(describing: count))"
        routine?.workout[indexPath.row].name = cell.workoutNameTextField?.text ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destination = storyboard.instantiateViewController(withIdentifier: "EditWorkoutViewController") as? EditWorkoutViewController, let workout = routine?.workout[indexPath.row] {
            
            destination.workout = workout
            
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        routineTableView.delegate = self
        routineTableView.dataSource = self
        setLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.routineTableView.reloadData()
    }
    
    private func setLabels(){
        guard let routineName = routine?.name else { return }
        routineNameLabel.text = routineName
    }
}
