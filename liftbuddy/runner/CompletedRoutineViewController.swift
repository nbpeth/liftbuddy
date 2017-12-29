import Foundation
import UIKit

class CompletedRoutineViewController: BaseViewController {
    var routineInProgress:RoutineInProgress?

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var embededRoutineSummaryTableViewController: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalWeightLabel: UILabel!
    
    
    @IBAction func saveButtonWasPressed(_ sender: Any) {
        guard let routineToSave = routineInProgress else { return }
        RealmManager.shared.beginWrite()
        
        RealmManager.shared.realm.add(routineToSave)
        RoutineManager.updateLastCompletedOnDateForRoutineWith(id: routineToSave.id)
        RealmManager.shared.saveChanges()
        
        completeRoutineSegue()
    }
    
    @IBAction func discardButtonWasPressed(_ sender: Any) {
        RealmManager.shared.discardChanges()
        completeRoutineSegue()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
        setTheme()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "configureVictorySummaryTableSegue" {
            guard let routine = routineInProgress,
                let embededTable = segue.destination as? RoutineSummaryTableViewController
                else {
                    embededRoutineSummaryTableViewController.isHidden = true
                    return
            }
            
            embededTable.completedRoutine = routine
            embededTable.tableView.reloadData()
        }
    }
    
    private func setTheme(){
        toolbar.barTintColor = Theme.tabBarColor

    }
    
    private func setLabels(){
        timeLabel.text = "\(calculateTime())"
        totalWeightLabel.text = "\(calculateWeight()) lbs."
    }
    
    private func calculateWeight() -> String {
        guard let routineInProgress = routineInProgress else { return "0" }
        
        return routineInProgress.totalWeightLifted()
    }
    
    private func calculateTime() -> String {
        guard let routineInProgress = routineInProgress else { return "0" }

        routineInProgress.endDate = Date()
        
        return routineInProgress.activityTimeFormatted()
    }
    
    private func completeRoutineSegue(){
        self.navigationController?.popToRootViewController(animated: true)
    }
}
