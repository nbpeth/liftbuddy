import UIKit
import Foundation

class WorkoutInRunnerTableViewCell: UITableViewCell {

    @IBOutlet weak var doneIndicator: UIButton!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var setNumberLabel: UILabel!
    
    @IBAction func doneViewWasPressed(_ sender: Any) {
        guard let lift = lift else { return }
        lift.completed = lift.completed ? false : true
        setDoneIndicatorColor()
    }
    var lift:LiftInProgress?
    
    func setDoneIndicatorColor(){
        guard let lift = lift else { return }
        doneIndicator.backgroundColor = lift.completed ? Theme.blue : Theme.tabBarColor

    }
    
    @IBAction func repsForLiftValueChanged(_ sender: Any) {
        guard let text = repsTextField.text, let textAsInt = Int(text) else { return }
        self.lift?.reps.value = textAsInt
    }
    
    @IBAction func weightForLiftValueChanged(_ sender: Any) {
        guard let text = weightTextField.text, let textAsDouble = Double(text) else { return }
        self.lift?.weight.value = textAsDouble
    }
    
}
