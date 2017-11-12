import Foundation
import UIKit

class WorkoutCell: UITableViewCell {
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var workoutNameTextField: UITextField!
    @IBOutlet weak var numberOfSetsLabel: UILabel!
    var workout:Workout?

}
