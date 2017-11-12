import Foundation
import UIKit

class EditWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var workout:Workout?
    @IBOutlet weak var liftsInWorkoutTableView: UITableView!
    @IBOutlet weak var workoutNameLabel: UILabel!
    
    @IBAction func addLiftButtonWasPressed(_ sender: Any) {
        workout!.lifts.append(Lift())
        
        self.liftsInWorkoutTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout!.lifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "liftCell", for: indexPath) as? LiftCell else { return UITableViewCell() }
        
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        liftsInWorkoutTableView.delegate = self
        liftsInWorkoutTableView.dataSource = self
        
        workoutNameLabel.text = workout!.name
        
    }
    
}
