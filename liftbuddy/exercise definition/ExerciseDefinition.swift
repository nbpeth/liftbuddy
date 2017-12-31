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

class ExerciseDefinitionManager {
    static func getAllExercises() -> [ExerciseDefinition] {
        return RealmManager().realm.objects(ExerciseDefinition.self).map { $0 }
    }
    
    static func saveCustomExerciseDefinition(exerciseDefinitions:[String]){
        
        exerciseDefinitions.forEach {
            RealmManager.shared.realm.add(ExerciseDefinition(muscleGroup:"My Lifts",name:$0))
        }
    }
}
