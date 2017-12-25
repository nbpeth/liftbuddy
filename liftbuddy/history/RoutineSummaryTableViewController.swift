import UIKit

class RoutineSummaryTableViewController: UITableViewController {
    var completedRoutine:RoutineInProgress?
    var historicalRoutine:RoutineInProgress?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "routineSummaryTableViewCell") as? RoutineSummaryTableViewCell
            else { return RoutineSummaryTableViewCell() }
        let liftRelativeToWorkout = Int(ceil(Double(indexPath.row) / (Double(indexPath.section + 1))))
    
        cell.workoutNameLabel.text = completedRoutine?.workout[indexPath.section].name
        cell.weightLabel.text = "Weight: \(String(describing:completedRoutine?.workout[indexPath.section].lifts[liftRelativeToWorkout].weight.value ?? 0))"
        cell.repsLabel.text = "Reps: \(String(describing:completedRoutine?.workout[indexPath.section].lifts[liftRelativeToWorkout].reps.value ?? 0))"
        cell.setNumberLabel.text = "\(String(describing:liftRelativeToWorkout + 1)). "
        
        if indexPath.section % 2 == 0 {
            cell.backgroundColor = Theme.cellSelectedBackgroundColor.withAlphaComponent(0.1)
        }
        else{
            cell.backgroundColor = Theme.alternateCellSelectedBackgroundColor.withAlphaComponent(0.1)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let completedRoutine = completedRoutine else { return "" }

        return completedRoutine.workout[section].name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let completedRoutine = completedRoutine else { return 0 }
        
        return completedRoutine.workout[section].lifts.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let completedRoutine = completedRoutine else { return 0 }
        
        return completedRoutine.workout.count
    }
}
