import Foundation
import UIKit

class LiftCell: UITableViewCell {
    @IBOutlet weak var repsPickerView: UIPickerView!
    @IBOutlet weak var weightPickerView: UIPickerView!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var setNumberLabel: UILabel!
    var lift:Lift?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    @IBAction func repsTextFieldChanged(_ sender: Any) {
        guard let lift = lift, let reps = repsTextField.text else { return }
        lift.reps.value = Int(reps)
        self.lift = lift
    }
    
    @IBAction func weightTextFieldChanged(_ sender: Any) {
        guard let lift = lift, let weight = weightTextField.text else { return }
        lift.weight.value = Double(weight)
        self.lift = lift
    }
}

extension UITextField {
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
