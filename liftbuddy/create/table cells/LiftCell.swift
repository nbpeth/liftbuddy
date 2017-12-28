import Foundation
import UIKit

extension LiftCell: UIPickerViewDataSource, UIPickerViewDelegate {
        
    var repsArray: [Int] {
        var numbers = [Int]()
        for i in 0 ... 100 {
            numbers.append(i)
        }
        return numbers
    }
    
    var weightArray: [Double] {
        var numbers = [Double]()
        for i in stride(from: 0.0, to: 1000, by: 2.5) {
            numbers.append(i)
        }
        return numbers
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return repsArray.count
        }
        else {
            return weightArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return String(describing:repsArray[row])
        }
        else {
            return String(describing:weightArray[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let thisLift = lift else { return }
        
        if pickerView.tag == 0 {
            thisLift.reps.value = repsArray[row]
        }
        else {
            thisLift.weight.value = weightArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title = ""
        if pickerView.tag == 0 {
            title = String(describing:repsArray[row])
        }
        else {
            title =  String(describing:weightArray[row])
        }
        
        let pickerLabel = UILabel()
        let titleData = title
        let font = UIFont.boldSystemFont(ofSize: 20.0)
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:font,NSAttributedStringKey.foregroundColor:Theme.yellow])
        pickerLabel.attributedText = myTitle
        return pickerLabel
    }
}

class LiftCell: UITableViewCell {
    @IBOutlet weak var repsPickerView: UIPickerView!
    @IBOutlet weak var weightPickerView: UIPickerView!

    var lift:Lift?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        repsPickerView.dataSource = self
        repsPickerView.delegate = self
        
        weightPickerView.dataSource = self
        weightPickerView.delegate = self
    
    }
    
}
