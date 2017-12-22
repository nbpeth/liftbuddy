import Foundation
import UIKit

class NameYourRoutineViewController: BaseViewController, UITextFieldDelegate {
    var routine: Routine?
    @IBOutlet weak var routineNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routineNameTextField.delegate = self
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
