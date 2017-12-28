import UIKit

class RoutineSummaryTableViewController: UITableViewController {
    var completedRoutine:RoutineInProgress?
    var historicalRoutine:RoutineInProgress?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "routineSummaryTableViewCell") as? RoutineSummaryTableViewCell,
            let completedRoutine = completedRoutine
        else { return RoutineSummaryTableViewCell() }
        
        let liftForRow = completedRoutine.workout[indexPath.section].lifts[indexPath.row]

        cell.repsLabel.text = "\(String(describing: liftForRow.reps.value ?? 0)) reps. "
        cell.weightLabel.text = "\(String(describing: liftForRow.weight.value ?? 0.0)) lbs "
        
        cell.setNumberLabel.text = ""

        cell.backgroundColor = Theme.alternateCellSelectedBackgroundColor.withAlphaComponent(0.1)
        
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
