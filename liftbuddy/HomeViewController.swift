import UIKit

class HomeViewController: BaseTableViewController {
   
    @IBOutlet weak var lastDateCompletedLabel: UILabel!
    @IBOutlet weak var timesCompletedLabel: UILabel!
    @IBOutlet weak var daysSinceLastWorkoutLabel: UILabel!
    @IBOutlet weak var routineNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timesCompletedLabelLabel: UILabel!
    
    
    @IBOutlet weak var routineNameCell: UITableViewCell!
    @IBOutlet weak var titleCell: UITableViewCell!
    @IBOutlet weak var timesCompletedCell: UITableViewCell!
    @IBOutlet weak var lastWorkoutDateCompletedCell: UIView!
    @IBOutlet weak var daysSinceLastWorkoutcell: UITableViewCell!
    
    func setTheme(){
        titleCell.backgroundColor = Theme.cellSelectedBackgroundColor.withAlphaComponent(0.8)
        routineNameCell.backgroundColor = Theme.cellSelectedBackgroundColor.withAlphaComponent(0.8)
        timesCompletedCell.backgroundColor = Theme.cellSelectedBackgroundColor.withAlphaComponent(0.8)
        lastWorkoutDateCompletedCell.backgroundColor = Theme.cellSelectedBackgroundColor.withAlphaComponent(0.8)
        daysSinceLastWorkoutcell.backgroundColor = Theme.cellSelectedBackgroundColor.withAlphaComponent(0.8)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTheme()
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
