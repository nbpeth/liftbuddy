import UIKit

class RoutineSummaryTableViewController: UITableViewController {
    var completedRoutine:RoutineInProgress?
    var historicalRoutine:RoutineInProgress?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(completedRoutine)
        print(historicalRoutine)
    }
}
