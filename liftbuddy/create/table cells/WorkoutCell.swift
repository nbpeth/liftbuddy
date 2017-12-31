import Foundation
import UIKit

extension WorkoutCell: UIPickerViewDataSource, UIPickerViewDelegate {
    
    var restArray: [Int] {
        var numbers = [Int]()
        for i in stride(from: 0, to: 1000, by: 5) {
            numbers.append(i)
        }
        return numbers
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return restArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing:restArray[row])
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let workoutToEdit = workout else { return }
        workoutToEdit.rest.value = restArray[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let title = String(describing:restArray[row])
        
        let pickerLabel = UILabel()
        let titleData = title
        let font = UIFont.boldSystemFont(ofSize: 20.0)
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:font,NSAttributedStringKey.foregroundColor:Theme.yellow])
        pickerLabel.attributedText = myTitle
        return pickerLabel
    }
}

class WorkoutCell: UITableViewCell {
    @IBOutlet weak var workoutNameTextField: UITextField!
    @IBOutlet weak var numberOfSetsLabel: UILabel!
    @IBOutlet weak var restPicker: UIPickerView!
    @IBOutlet weak var workoutNameLabel: UILabel!
    var workout:Workout?
    var name = ""
    var rest = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        restPicker.dataSource = self
        restPicker.delegate = self
    }
}
