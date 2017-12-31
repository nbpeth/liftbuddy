import UIKit
import Foundation

extension WorkoutInRunnerTableViewCell: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        repsTextField.resignFirstResponder()
        weightTextField.resignFirstResponder()

        return true
    }
}

class WorkoutInRunnerTableViewCell: UITableViewCell {

    @IBOutlet weak var doneIndicator: UIButton!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
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
    
    override func awakeFromNib() {
        repsTextField.delegate = self
        weightTextField.delegate = self
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
