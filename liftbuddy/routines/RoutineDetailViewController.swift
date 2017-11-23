import Foundation
import UIKit
import RealmSwift

class RoutineDetailViewController: UIViewController {
    @IBOutlet weak var routineNameLabel: UILabel!
    var routineId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        
        guard let id = routineId,
            let routine = realm.objects(Routine.self).filter("id == \(String(describing: id))").first
        else { return }
        
        routineNameLabel.text = routine.name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editExistingRoutineSegue" {
            
            if let destination = segue.destination as? CreateRoutineViewController {
                destination.routineId = routineId
            }
        }
    }
    
}
