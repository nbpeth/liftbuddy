import UIKit
import Foundation

protocol LiftRefresher {
    func reload()
}

class WorkoutInRunnerTableViewCell: UITableViewCell {

    @IBOutlet weak var doneIndicator: UIButton!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var setNumberLabel: UILabel!
    @IBOutlet weak var coolXLabel: UILabel!
    @IBOutlet weak var addSetButton: UIButton!
    
    weak var delegate:RoutineRunnerViewController?
    
    @IBAction func doneViewWasPressed(_ sender: Any) {
        guard let lift = lift else { return }
        lift.completed = lift.completed ? false : true
        setDoneIndicatorColor()
    }
    
    var lift:LiftInProgress?
    var workout:WorkoutInProgress?
    
    func setDoneIndicatorColor(){
        guard let lift = lift else { return }
        doneIndicator.backgroundColor = lift.completed ? Theme.blue : Theme.tabBarColor

    }
    @IBAction func addSetButtonWasPressed(_ sender: Any) {
        guard let workout = workout else { return }
        workout.addLift()
        delegate?.reload()
        
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
