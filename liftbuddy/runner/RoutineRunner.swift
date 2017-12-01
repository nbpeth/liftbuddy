import Foundation
import RealmSwift

class RoutineRunner {
    
    var routine:Routine?
    var currentWorkout:Workout?
    var liftIndex = 0
    var workoutIndex = 1
    var timer: Timer?
//    var liftIterator:RLMIterator<Lift>? // iterator.next() keeps throwing bad access exception at runtime, but not in lldb
//    var workoutIterator:RLMIterator<Workout>?
    
    init(routine:Routine){
        self.routine = routine
        self.currentWorkout = routine.workout.first
        
//        self.liftIterator = currentWorkout?.lifts.makeIterator()
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

    func nextLiftSetIn(workout: Workout) -> Lift {
        var iterator = workout.lifts.makeIterator()
        
        guard let nextLift = iterator.next() else { return Lift() }
        
        return nextLift
    }
    
    func numberOfWorkoutsInRoutine() -> Int {
        return routine?.workout.count ?? 0
    }
    
    func restTimeForCurrentWorkout() -> Int {
        return currentWorkout?.rest.value ?? 0
    }
    
    func changeWorkoutPosition(to index:Int){
        guard let routine = routine,
            let workout = routine.workout[index] as? Workout
        else { return }
        
        self.currentWorkout = workout
        workoutIndex = index + 1
        liftIndex = 0
    }
   
    
}
