import Foundation
import UIKit

extension EditWorkoutViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func data(_ max:Int) -> [Int] {
        var numbers = [Int]()
        for i in 1 ... max {
            numbers.append(i)
        }
        return numbers
    }
    
    func data(_ max:Double) -> [Double] {
        var numbers = [Double]()
        for i in stride(from: 0.0, to: max, by: 2.5) {
            numbers.append(i)
        }
        return numbers
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.restorationIdentifier == "repsPickerView" {
            return data(100).count
        }
        else {
            return data(1000.0).count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.restorationIdentifier == "repsPickerView" {
            return String(describing:data(100)[row])
        }
        else {
            return String(describing:data(1000.0)[row])
        }
        
    }
}

class EditWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var workout:Workout?
    @IBOutlet weak var liftsInWorkoutTableView: UITableView!
    @IBOutlet weak var workoutNameLabel: UILabel!
    
    @IBAction func addLiftButtonWasPressed(_ sender: Any) {
        workout!.lifts.append(Lift())
        
        self.liftsInWorkoutTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout!.lifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "liftCell", for: indexPath) as? LiftCell else {
            return UITableViewCell()
        }
        
        cell.repsPickerView.dataSource = self
        cell.repsPickerView.delegate = self
        
        cell.weightPickerView.dataSource = self
        cell.weightPickerView.delegate = self
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        liftsInWorkoutTableView.delegate = self
        liftsInWorkoutTableView.dataSource = self
        
        workoutNameLabel.text = workout!.name
        
    }
    
}
