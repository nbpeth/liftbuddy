import UIKit
import Foundation

class CreateOrEditWorkoutViewController: BaseViewController, UITextFieldDelegate {
    var workout:Workout?
    @IBOutlet weak var workoutNameTextField: UITextField!
    @IBOutlet weak var setsLabel: UILabel!
    
    @IBAction func workoutNameChanged(_ sender: Any) {
        guard let workout = workout, let name = workoutNameTextField.text else { return }
        
        workout.name = name
        workoutNameTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        workoutNameTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func workoutNameEditingChanged(_ sender: Any) {
        guard let workout = workout, let name = workoutNameTextField.text else { return }
        
        workout.name = name
    }
    
    @IBAction func workoutNameValueChanged(_ sender: Any) {
        guard let workout = workout, let name = workoutNameTextField.text else { return }
        
        workout.name = name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let setsCount = workout?.lifts.count else { return }
        
        workoutNameTextField.text = workout?.name ?? ""
        setsLabel.text = String(describing:setsCount)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSetsToWorkoutSegue", let destination = segue.destination as? EditWorkoutViewController {
            
            destination.workout = workout
            
        }
    }
}
