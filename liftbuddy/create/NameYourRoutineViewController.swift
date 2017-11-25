import Foundation
import UIKit

class NameYourRoutineViewController: UIViewController {
    var routine: Routine?
    @IBOutlet weak var routineNameTextField: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? EditRoutineViewController {
            let routineName = routineNameTextField.text ?? "Unnamed Workout"
            
            routine = Routine(name: routineName)
            
            destinationViewController.routine = routine
        }
    }

}
