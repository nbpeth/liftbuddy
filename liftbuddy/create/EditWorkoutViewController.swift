import Foundation
import UIKit

class EditWorkoutViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var liftsInWorkoutTableView: UITableView!
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    var workout:Workout?

    @IBAction func addLiftButtonWasPressed(_ sender: Any) {
        guard let workoutToEdit = workout else { return }
        
        workoutToEdit.addLift()
        
        self.liftsInWorkoutTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        workoutNameLabel.text = workout?.name ?? ""
        
        setDelegates()
        setNavigationItems()
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

        if indexPath.row % 2 == 0 {
            cell.backgroundColor = Theme.cellSelectedBackgroundColor.withAlphaComponent(0.8)
        }
        else {
            cell.backgroundColor = Theme.alternateCellSelectedBackgroundColor.withAlphaComponent(0.8)
            
        }
        
        if let weightIndex = cell.weightArray.index(of: liftToEdit.weight.value ?? 0.0)  {
            cell.weightPickerView.selectRow(weightIndex , inComponent: 0, animated: true)
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
    
    private func setNavigationItems(){
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(popNavigationToRoutineViewController))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func popNavigationToRoutineViewController(){
        guard let navigationController = self.navigationController else { return }
        let viewControllerToPopTo = navigationController.viewControllers[(navigationController.viewControllers.count) - 3]
        self.navigationController?.popToViewController(viewControllerToPopTo, animated: true)
    }
    
}
