import Foundation
import RealmSwift

class ExerciseDefinition: Object {
    @objc dynamic var muscleGroup:String?
    @objc dynamic var name:String?
    
    convenience init(muscleGroup:String, name:String){
        self.init()
        self.muscleGroup = muscleGroup
        self.name = name
    }

}
