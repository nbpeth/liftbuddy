import UIKit
import Foundation
import RealmSwift

class HistoryTableViewController: UITableViewController {
    var completedRoutines = [RoutineInProgress]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        completedRoutines = RoutineManager.getAllRoutinesInProgress()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedRoutines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as? HistoryTableViewCell else { return HistoryTableViewCell() }
        
        cell.routineNameLabel.text = completedRoutines[indexPath.row].name
        cell.dateCompletedLabel.text = String(describing:completedRoutines[indexPath.row].endDate!)
        
        return cell
    }
    
}
