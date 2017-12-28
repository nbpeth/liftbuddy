import UIKit
import Foundation
import RealmSwift

class HistoryTableViewController: BaseTableViewController {
    var completedRoutines = [RoutineInProgress]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        completedRoutines = RoutineManager.getAllHistoryRoutines()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            let routinesToDelete = [indexPath].map { completedRoutines[$0.row]}
            [indexPath].forEach { completedRoutines.remove(at: $0.row) }
            
            RoutineManager.deleteHistoryRoutines(routinesToDelete)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
