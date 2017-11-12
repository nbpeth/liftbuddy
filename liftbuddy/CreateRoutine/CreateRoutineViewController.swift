import Foundation
import UIKit

class CreateRoutineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var routineTableView: UITableView!
    @IBOutlet weak var routineNameLabel: UILabel!
    var routine: Routine?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfWorkouts = routine?.workout.count else { return 0 }
        
        return numberOfWorkouts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as? WorkoutCell else { return UITableViewCell() }

        cell.workoutNameLabel.text = "New Lift"
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        routineTableView.delegate = self
        routineTableView.dataSource = self
        setLabels()
        
    }
    
    private func setLabels(){
        guard let routineName = routine?.name else { return }
        routineNameLabel.text = routineName
    }
    
    @IBAction func addWorkoutButtonWasPressed(_ sender: Any) {
        routine?.workout.append(Workout())

        self.routineTableView.reloadData()
    }
}
