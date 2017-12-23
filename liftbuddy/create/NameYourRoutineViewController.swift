import Foundation
import UIKit

class NameYourRoutineViewController: BaseViewController, UITextFieldDelegate {
    var routine: Routine?
    @IBOutlet weak var routineNameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func routineNameTextFieldEditingChanged(_ sender: Any) {
        guard let text = routineNameTextField.text else {
            return
        }
        
        if text.count > 0 {
            nextButton.isEnabled = true
        }
        else{
            nextButton.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routineNameTextField.delegate = self
        nextButton.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? EditRoutineViewController {
            let routineName = routineNameTextField.text ?? "Unnamed Workout"
            
            routine = Routine(name: routineName)
            
            destinationViewController.routine = routine
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        routineNameTextField.resignFirstResponder()
        return true
    }

}
