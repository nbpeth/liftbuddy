import Foundation
import UIKit

class WorkoutCell: UITableViewCell {
    @IBOutlet weak var numberOfSetsLabel: UILabel!
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var restTextField: UITextField!
    var workout:Workout?
    var name = ""
    
    @IBAction func restChanged(_ sender: Any) {
        guard let workout = workout,
            let rest = restTextField.text else { return }
        workout.rest.value = Int(rest)
        self.workout = workout
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
}
