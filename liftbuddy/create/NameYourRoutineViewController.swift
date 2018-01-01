import Foundation
import UIKit

class NameYourRoutineViewController: BaseViewController, UITextFieldDelegate {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        routineNameTextField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditRoutineViewController {
            createRoutineWithName(destination)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        routineNameTextField.resignFirstResponder()
        
        guard let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editRoutineViewController") as? EditRoutineViewController
            else { return true }
        
        createRoutineWithName(destination)
        
        self.navigationController?.pushViewController(destination, animated: true)
        
        return true
    }
    
    private func createRoutineWithName(_ destination:EditRoutineViewController){
        let routineName = routineNameTextField.text ?? "Unnamed Workout"
        let routine = Routine(name: routineName)
        routine.addWorkout(id: routine.id)
        destination.routine = routine
    }

}
