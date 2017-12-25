import UIKit

class HistorySummaryViewController: BaseViewController {
    @IBOutlet weak var dateCompletedLabel: UILabel!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var totalWeightLabel: UILabel!
    @IBOutlet weak var routineNameLabel: UILabel!
    @IBOutlet weak var embededRoutineSummaryTableViewController: UIView!
    
    var routine:RoutineInProgress?
    var historicalRoutine:RoutineInProgress?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
        historicalRoutine = getLastRoutineCompletedById()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "configureHistoricalSummaryTableSegue" {
            guard let routine = routine,
                let embededTable = segue.destination as? RoutineSummaryTableViewController
            else {
                embededRoutineSummaryTableViewController.isHidden = true
                return
            }
            
            embededTable.completedRoutine = routine
            embededTable.historicalRoutine = historicalRoutine
            embededTable.tableView.reloadData()
        }
    }
    
    private func setLabels(){
        guard let routine = routine, let endDate = routine.endDate else { return }
        routineNameLabel.text = routine.name
        dateCompletedLabel.text = DateUtils.formatMMDDYYYY(date: endDate)
        timeElapsedLabel.text = routine.activityTimeFormatted()
        totalWeightLabel.text = "\(routine.totalWeightLifted()) lbs"
    }
    
    private func getLastRoutineCompletedById() -> RoutineInProgress? {
        guard let routine = routine else { return nil }
        
        return RoutineManager.getPreviousRoutineInProgressBy(id: routine.id)
    }
    
}
