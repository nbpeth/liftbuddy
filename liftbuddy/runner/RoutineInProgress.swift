import Foundation
import RealmSwift

class RoutineInProgress: Object {
    @objc dynamic var startDate: Date?
    @objc dynamic var endDate: Date?

    @objc dynamic var name = ""
    @objc dynamic var id = 0
    var workout = List<WorkoutInProgress>()
    
    convenience init(routine:Routine){
        self.init()
        self.startDate = Date()
        self.endDate = Date()
        self.name = routine.name
        self.id = routine.id
        
        for workoutToCopy in routine.workout {
            let copiedWorkout = WorkoutInProgress()
            copiedWorkout.name = workoutToCopy.name
            copiedWorkout.group = workoutToCopy.group
            copiedWorkout.rest.value = workoutToCopy.rest.value
            
            for liftsToCopy in workoutToCopy.lifts {
                let copiedLift = LiftInProgress()
                copiedLift.name = liftsToCopy.name
                copiedLift.reps.value = liftsToCopy.reps.value
                copiedLift.weight.value = liftsToCopy.weight.value
                
                copiedWorkout.lifts.append(copiedLift)
            }
            self.workout.append(copiedWorkout)
        }
    }
    
    func removeWorkout(at index:Int){
        RealmManager.shared.realm.delete(workout[index])
    }
    
    func getNextId() -> Int {
        let realm = try! Realm()
        return (realm.objects(RoutineInProgress.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    func isComplete() -> Bool {
        let incompleteWorkouts = workout.filter { workout in return !workout.isComplete() }
        return incompleteWorkouts.count <= 0
    }
    
    func activityTimeComponents() -> DateComponents? {
        guard let startDate = startDate, let endDate = endDate else { return nil }
        
        return DateUtils.differenceBetween(startDate, endDate)
    }
    
    func activityTimeFormatted() -> String {
        guard let components = activityTimeComponents() else { return "0" }
        return  "\(String(describing: components.hour ?? 0)):\(components.minute ?? 0):\(components.second ?? 0)"
    }
    
    func totalWeightLifted() -> String {
        var total = 0.0
        
        for workout in self.workout {
            for lift in workout.lifts {
                let weight = lift.weight.value ?? 0.0
                let reps = Double(lift.reps.value ?? 0)
                
                total += (reps * weight)
            }
        }
        
        return String(describing: total)
    }
}

class WorkoutInProgress: Object {
    @objc dynamic var name = ""
    var group = ""
    var rest = RealmOptional<Int>()
    var lifts = List<LiftInProgress>()
    
    convenience init(name:String, group:String, rest: RealmOptional<Int>, lifts:List<LiftInProgress>){
        self.init()
        self.name = name
        self.group = group
        self.rest = rest
        self.lifts = lifts
    }
    
    func addLift(){
        self.lifts.append(LiftInProgress(name: self.name))
    }
    
    func removeLift(at index: Int){
        self.lifts.remove(at: index)
    }
    
    func isComplete() -> Bool {
        let incompleteLifts = lifts.filter { lift in return !lift.completed }
        return incompleteLifts.count <= 0
    }
}

class LiftInProgress: Object {
    @objc dynamic var name = ""
    @objc dynamic var completed = false
    var reps = RealmOptional<Int>()
    var weight = RealmOptional<Double>()
    
    func setReps(reps:Int){
        self.reps.value = reps
    }
    
    func setWeight(weight:Double){
        self.weight.value = weight
    }
    
    convenience init(name:String){
        self.init()
        self.name = name
    }
    
    convenience init(reps:RealmOptional<Int>, weight:RealmOptional<Double>, name:String){
        self.init()
        self.reps = reps
        self.weight = weight
        self.name = name
    }
}

