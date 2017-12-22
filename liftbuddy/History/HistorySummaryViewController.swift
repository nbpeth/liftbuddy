import UIKit

class HistorySummaryViewController: BaseViewController {
    @IBOutlet weak var dateCompletedLabel: UILabel!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var totalWeightLabel: UILabel!
    @IBOutlet weak var routineNameLabel: UILabel!
    
    var routine:RoutineInProgress?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
    }
    
    private func setLabels(){
        guard let routine = routine, let endDate = routine.endDate else { return }
        routineNameLabel.text = routine.name
        dateCompletedLabel.text = DateUtils.formatMMDDYYYY(date: endDate)
        timeElapsedLabel.text = routine.activityTimeFormatted()
        totalWeightLabel.text = "\(routine.totalWeightLifted()) lbs"
    }
}
