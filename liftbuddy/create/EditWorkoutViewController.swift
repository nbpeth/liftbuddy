import Foundation
import UIKit

class EditWorkoutViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var workout:Workout?
    @IBOutlet weak var liftsInWorkoutTableView: UITableView!
    @IBOutlet weak var workoutNameLabel: UILabel!
    
    @IBAction func addLiftButtonWasPressed(_ sender: Any) {
        guard let workoutToEdit = workout else { return }
        
        workoutToEdit.addLift()
        
        self.liftsInWorkoutTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            guard let workoutToDeleteFrom = workout else { return }
            
            if workoutToDeleteFrom.lifts.count >= indexPath.row {
                workoutToDeleteFrom.lifts.remove(at: indexPath.row)
                self.liftsInWorkoutTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            self.liftsInWorkoutTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout?.lifts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "liftCell", for: indexPath) as? LiftCell,
            let liftToEdit = workout?.lifts[indexPath.row]
        else {
            return UITableViewCell()
        }
        
        cell.lift = liftToEdit        
        cell.repsPickerView.selectRow(liftToEdit.reps.value ?? 0 , inComponent: 0, animated: false)
//        cell.backgroundColor = Theme.cellBackgroundColor
        
        if let weightIndex = cell.weightArray.index(of: liftToEdit.weight.value ?? 0.0)  {
            cell.weightPickerView.selectRow(weightIndex , inComponent: 0, animated: true)
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        liftsInWorkoutTableView.delegate = self
        liftsInWorkoutTableView.dataSource = self
        
        workoutNameLabel.text = workout?.name ?? ""
        
//        self.liftsInWorkoutTableView.backgroundColor = Theme.backgroundColor
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.liftsInWorkoutTableView.reloadData()
    }
    
}
