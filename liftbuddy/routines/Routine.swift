import RealmSwift
import Foundation

class RoutineManager {
    
    static func updateLastCompletedOnDateForRoutineWith(id: Int){
        guard let routineToUpdate = RealmManager.shared.realm.objects(Routine.self)
            .filter("id == \(String(describing: id))")
            .first
            else { return }
        
        routineToUpdate.lastCompletedDate = Date()
    }
    
    static func getAllRoutines() -> [Routine] {
        return RealmManager.shared.realm.objects(Routine.self).sorted(byKeyPath: "name").map { routine in return routine }
    }
    
    static func getRoutineBy(id:Int) -> Routine? {
        return RealmManager.shared.realm.objects(Routine.self).filter("id == \(String(describing: id))").first
    }
    
    static func create(routine:Routine) {
        RealmManager.shared.realm.add(routine)
    }
    
    static func deleteHistoryRoutines(_ historyRoutines:[RoutineInProgress]) {
        RealmManager.shared.beginWrite()
        
        RealmManager.shared.realm.delete(historyRoutines)
        
        RealmManager.shared.saveChanges()
    }
    
    static func searchHistoryFor(_ searchText: String) -> [RoutineInProgress] {
        return RealmManager.shared.realm.objects(RoutineInProgress.self)
            .filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    static func getAllHistoryRoutines() -> [RoutineInProgress] {
        return RealmManager.shared.realm.objects(RoutineInProgress.self)
            .sorted(byKeyPath: "endDate")
            .map { routine in return routine }
            .reversed()
    }
    
    static func getPreviousRoutineInProgressBy(id:Int) -> RoutineInProgress? {
        let routinesById = RealmManager.shared.realm.objects(RoutineInProgress.self)
            .filter("id == \(String(describing: id))")
            .sorted(byKeyPath: "endDate")

        return routinesById.count > 1 ? routinesById[1] : nil
    }
    
    static func getLastCompletedRoutine() -> RoutineInProgress? {
        return RealmManager.shared.realm.objects(RoutineInProgress.self)
            .sorted(byKeyPath: "endDate")
            .map { routine in return routine }
            .reversed()
            .first
    }
}

class Routine: Object {
    @objc dynamic var name = ""
    @objc dynamic var id = 0
    var workout = List<Workout>()
    
    @objc dynamic var lastCompletedDate:Date?
    
    convenience init(name:String, workout:List<Workout>, id:Int){
        self.init()
        self.id = id
        self.name = name
        self.workout = workout
    }
    
    convenience init(name:String){
        self.init()
        self.id = getNextId()
        self.name = name
    }
    
    func addWorkout(id:Int){
        let routine = RoutineManager.getRoutineBy(id: id)
        let newWorkout = Workout(name:"New Lift")
        newWorkout.lifts.append(Lift(name: "New Lift"))
        routine?.workout.append(newWorkout)
    }
    
    func removeWorkout(at index:Int){
        RealmManager.shared.realm.delete(workout[index])
    }
    
    func getNextId() -> Int {
        let realm = try! Realm()
        return (realm.objects(Routine.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    func isComplete() -> Bool {
        let incompleteWorkouts = workout.filter { workout in return !workout.isComplete() }
        return incompleteWorkouts.count <= 0
    }
    
    override class func primaryKey() -> String? {
        return "id"
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
    
    convenience init(name:String){
        self.init()
        self.name = name
    }
    
    func addLift(){
        self.lifts.append(Lift(name: self.name))
    }
    
    func removeLift(at index: Int){
        self.lifts.remove(at: index)
    }
    
    func isComplete() -> Bool {
        let incompleteLifts = lifts.filter { lift in return !lift.completed }
        return incompleteLifts.count <= 0
    }
}

class Lift: Object {
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
