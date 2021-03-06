import UIKit
import Foundation
import RealmSwift

class HistoryTableViewController: BaseTableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    var completedRoutines = [RoutineInProgress]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        
        searchBar.delegate = self
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
            cell.backgroundColor = Theme.alternateCellSelectedBackgroundColor
        }
        else {
            cell.backgroundColor = Theme.cellSelectedBackgroundColor.withAlphaComponent(0.8)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HistorySummaryViewController") as? HistorySummaryViewController
            else { return }
        destination.routine = completedRoutines[indexPath.row]
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            completedRoutines = RoutineManager.getAllHistoryRoutines()
        }
        else {
            completedRoutines = RoutineManager.searchHistoryFor(searchText)
        }
        
        self.tableView.reloadData()
    }
    
    private func setTheme(){
        self.tableView.backgroundColor = Theme.inactiveCellColor
    }
    
}
