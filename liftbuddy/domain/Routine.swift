import RealmSwift
import Foundation

class Routine: Object {
    @objc dynamic var name = ""
    @objc dynamic var date = ""
    var workout = List<Workout>()
    
    convenience init(name:String, date: String, workout:List<Workout>){
        self.init()
        self.name = name
        self.date = date
        self.workout = workout
    }
}

class Workout: Object {
    @objc dynamic var name = ""
    var group = ""
    var rest = RealmOptional<Int>()
    var lifts = List<Lift>()
    
    convenience init(name:String, group:String, rest: RealmOptional<Int>, lifts:List<Lift>){
        self.init()
        self.name = name
        self.group = group
        self.rest = rest
        self.lifts = lifts
    }
    
}

class Lift: Object {
    @objc dynamic var name = ""
    var reps = RealmOptional<Int>()
    var weight = RealmOptional<Int>()
    
    convenience init(name:String, reps: RealmOptional<Int>, weight: RealmOptional<Int>){
        self.init()
        self.name = name
        self.reps = reps
        self.weight = weight
    }
    
    
}
