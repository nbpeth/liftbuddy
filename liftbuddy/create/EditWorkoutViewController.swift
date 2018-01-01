import Foundation
import UIKit

class EditWorkoutViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var liftsInWorkoutTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    var workout:Workout?

    @IBAction func addLiftButtonWasPressed(_ sender: Any) {
        guard let workoutToEdit = workout else { return }
        
        workoutToEdit.addLift()
        
        self.liftsInWorkoutTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        setTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

        cell.repsTextField.text = String(describing: liftToEdit.reps.value ?? 0)
        cell.weightTextField.text = String(describing: liftToEdit.weight.value ?? 0)
        cell.setNumberLabel.text = "\(String(describing: indexPath.row + 1))."
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = Theme.cellSelectedBackgroundColor.withAlphaComponent(0.8)
        }
        else {
            cell.backgroundColor = Theme.alternateCellSelectedBackgroundColor.withAlphaComponent(0.8)
            
        }
    
        return cell
    }
    
    private func setTheme(){
        self.liftsInWorkoutTableView.backgroundColor = Theme.backgroundColor
        self.headerView.backgroundColor = Theme.foregroundColor
    }
    
    private func setDelegates(){
        liftsInWorkoutTableView.delegate = self
        liftsInWorkoutTableView.dataSource = self
    }
}
