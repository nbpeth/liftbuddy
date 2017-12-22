import Foundation
import UIKit

class CompletedRoutineViewController: BaseViewController {
    var routineInProgress:RoutineInProgress?
    
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
    }
    
    private func completeRoutineSegue(){
        self.navigationController?.popToRootViewController(animated: true)
    }
}
