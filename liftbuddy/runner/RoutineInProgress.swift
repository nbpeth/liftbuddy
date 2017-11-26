import Foundation
import RealmSwift

class RoutineInProgress: Object {
    @objc dynamic var routine: Routine?
    @objc dynamic var date: Date?
    
    convenience init(routine:Routine){
        self.init()
        self.routine = routine
        self.date = Date()
    }
    
    
}
