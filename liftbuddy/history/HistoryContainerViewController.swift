import UIKit

class HistoryContainerViewController: UIViewController {
    @IBOutlet weak var historyTableView: UIView!
    @IBOutlet weak var noHistoryLabel: UILabel!
    var completedRoutines = [RoutineInProgress]()
    var embededTable:HistoryTableViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "historyTableEmbedSegue"{

            guard let destination = segue.destination as? HistoryTableViewController else { return }
            self.embededTable = destination
            
            destination.completedRoutines = completedRoutines
            
        }
    }
    
    private func setupTableView(){
        completedRoutines = RoutineManager.getAllHistoryRoutines()
        
        if completedRoutines.isEmpty {
            historyTableView.isHidden = true
            noHistoryLabel.isHidden = false
        }
        else {
            embededTable?.completedRoutines = completedRoutines
            historyTableView.isHidden = false
            noHistoryLabel.isHidden = true

        }
    }
}
