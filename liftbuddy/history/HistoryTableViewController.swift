import UIKit
import Foundation
import RealmSwift

class HistoryTableViewController: BaseTableViewController {
    var completedRoutines = [RoutineInProgress]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        completedRoutines = RoutineManager.getAllRoutinesInProgress()
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedRoutines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as? HistoryTableViewCell,
            let endDate = completedRoutines[indexPath.row].endDate
            else { return HistoryTableViewCell()
        }
        
        cell.routineNameLabel.text = completedRoutines[indexPath.row].name
        cell.dateCompletedLabel.text = DateUtils.formatMMDDYYYY(date: endDate)
        cell.elapsedTimeLabel.text = completedRoutines[indexPath.row].activityTimeFormatted()

        if indexPath.row % 2 == 0 {
            cell.backgroundColor = Theme.cellAlternateBackgroundColor.withAlphaComponent(0.3)
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HistorySummaryViewController") as? HistorySummaryViewController
            else { return }
        destination.routine = completedRoutines[indexPath.row]
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
}
