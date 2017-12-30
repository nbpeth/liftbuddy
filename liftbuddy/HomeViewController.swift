import UIKit

class HomeViewController: BaseTableViewController {
   
    @IBOutlet weak var lastDateCompletedLabel: UILabel!
    @IBOutlet weak var timesCompletedLabel: UILabel!
    @IBOutlet weak var daysSinceLastWorkoutLabel: UILabel!
    @IBOutlet weak var routineNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timesCompletedLabelLabel: UILabel!
    @IBOutlet weak var timesCompletedCell: UITableViewCell!
    @IBOutlet weak var lastWorkoutDateCompletedCell: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLabels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setLabels(){
        let routines = RoutineManager.getAllHistoryRoutines()
        
        configureLastWorkoutLabels(routines: routines)
        configureDaysSinceLastWorkoutCountLabel(routines:routines)
        
    }
    
    private func configureDaysSinceLastWorkoutCountLabel(routines: [RoutineInProgress]){
        guard let dates = (routines.map { $0.endDate }).first , let lastDate = dates else {
            daysSinceLastWorkoutLabel.text = "N/A"
            return
        }
        
        let inactiveTime = DateUtils.differenceBetween(lastDate, Date())
        let inactiveDays = inactiveTime.day ?? 0
        daysSinceLastWorkoutLabel.text = "\(inactiveDays)"
    }
    
    private func configureLastWorkoutLabels(routines:[RoutineInProgress]){
        guard let lastRoutine = routines.first,
            let completedDate = lastRoutine.endDate
            else{
                configureLabelsForNoWorkoutHistory()
                return
        }
        lastWorkoutDateCompletedCell.isHidden = false
        timesCompletedCell.isHidden = false
        
        let dateComponents = Calendar.current.dateComponents([.year,.month,.day], from: completedDate)
        let formattedDateString = "\(dateComponents.month ?? 1)/\(dateComponents.day ?? 1)/\(dateComponents.year ?? 1900)"
        timesCompletedLabel.text = String(describing: routines.filter{$0.name == lastRoutine.name}.count)
        routineNameLabel.text = lastRoutine.name
        lastDateCompletedLabel.text = formattedDateString
    }
    
    private func configureLabelsForNoWorkoutHistory(){
        routineNameLabel.text = "Complete a routine to get started!"
        lastWorkoutDateCompletedCell.isHidden = true
        timesCompletedCell.isHidden = true
    }
    
}
