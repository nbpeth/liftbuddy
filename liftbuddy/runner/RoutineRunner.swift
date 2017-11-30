import Foundation
import RealmSwift

class RoutineRunner {
    
    var routine:Routine?
    var currentWorkout:Workout?
    var liftIndex = 0
    var workoutIndex = 0
//    var liftIterator:RLMIterator<Lift>? // iterator.next() keeps throwing bad access exception at runtime, but not in lldb
//    var workoutIterator:RLMIterator<Workout>?
    
    init(routine:Routine){
        self.routine = routine
        self.currentWorkout = nextWorkout()
        
//        self.liftIterator = currentWorkout?.lifts.makeIterator()
    }

    func nextWorkout() -> Workout? {
        guard let routine = routine else { return nil }
        
        if routine.workout.endIndex > workoutIndex {
            let next = routine.workout[workoutIndex]
            workoutIndex += 1
            currentWorkout = next
            return next
        }
        
        workoutIndex = 0
        return nil
    }
    
    func nextLiftSet() -> Lift? {
        guard let currentWorkout = currentWorkout else { return nil }
        
        if currentWorkout.lifts.endIndex > liftIndex { // can't i just use a fucking iterator?
            let next = currentWorkout.lifts[liftIndex]
            liftIndex += 1
            return next
        }
        
        liftIndex = 0
        self.currentWorkout = nextWorkout()
        
        return nil
    }

    func nextLiftSetIn(workout: Workout) -> Lift {
        var iterator = workout.lifts.makeIterator()
        
        guard let nextLift = iterator.next() else { return Lift() }
        
        return nextLift
    }
    
    func numberOfWorkoutsInRoutine() -> Int {
        guard let routine = routine else { return 0 }
        
        return routine.workout.count

    }
    
}
