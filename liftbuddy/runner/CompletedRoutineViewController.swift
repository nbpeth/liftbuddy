import Foundation
import UIKit

class CompletedRoutineViewController: BaseViewController {
    var routineInProgress:RoutineInProgress?
    
    @IBAction func saveButtonWasPressed(_ sender: Any) {
        guard let routineToSave = routineInProgress else { return }
        RealmManager.shared.beginWrite()
        
        if(RoutineManager.getRoutineInProgressBy(id: routineToSave.id) == nil){
            RealmManager.shared.realm.add(routineToSave)
            RealmManager.shared.saveChanges()
        }
    }
    
    @IBAction func discardButtonWasPressed(_ sender: Any) {
        RealmManager.shared.discardChanges()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
