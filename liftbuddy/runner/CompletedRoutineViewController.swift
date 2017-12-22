import Foundation
import UIKit

class CompletedRoutineViewController: BaseViewController {
    var routineInProgress:RoutineInProgress?

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalWeightLabel: UILabel!
    
    
    @IBAction func saveButtonWasPressed(_ sender: Any) {
        guard let routineToSave = routineInProgress else { return }
        RealmManager.shared.beginWrite()
        
        RealmManager.shared.realm.add(routineToSave)
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
    }
    
    private func setLabels(){
        timeLabel.text = "Time: \(calculateTime())"
        totalWeightLabel.text = "Total Weight: \(calculateWeight()) lbs."
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
