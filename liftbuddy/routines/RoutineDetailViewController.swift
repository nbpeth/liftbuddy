import Foundation
import UIKit
import RealmSwift

class RoutineDetailViewController: BaseViewController {
    @IBOutlet weak var routineNameLabel: UILabel!
    @IBOutlet weak var toolbar: UIToolbar!

    var routineId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toolbar.barTintColor = Theme.tabBarColor
        //move this out to realmmanager
        let realm = try! Realm()
        
        guard let id = routineId,
            let routine = realm.objects(Routine.self).filter("id == \(String(describing: id))").first
        else { return }
        
        routineNameLabel.text = routine.name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editExistingRoutineSegue" {
            
            if let destination = segue.destination as? EditRoutineViewController {
                destination.routineId = routineId
            }
        }
        
        if segue.identifier == "startRoutineSegue" {
            if let destination = segue.destination as? RoutineRunnerViewController,
                let routineId = routineId,
                let routine = RoutineManager.getRoutineBy(id: routineId) {
                destination.routine = RoutineInProgress(routine:routine)
                                
            }
        }
    }
    
}
