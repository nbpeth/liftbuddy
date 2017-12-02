import Foundation
import RealmSwift

class RoutineRunner {
    
    var routine:Routine?
    var currentWorkout:Workout?
    var currentLift:Lift?
    var timer: Timer?
    var position = Position()
    
    init(routine:Routine){
        self.routine = routine
        self.currentWorkout = routine.workout.first
        self.currentLift = currentWorkout?.lifts.first
    }
    
    func nextLiftSet() {
        if workoutHasAnotherLift(workout: currentWorkout!, index: position.liftIndex) {
            position.advanceLift()
        }
        
        else {
            position.resetLifts()
            currentWorkout = nextWorkout()
        }
        
        currentLift = currentWorkout?.lifts[position.liftIndex]
        
    }
    
    func nextWorkout() -> Workout? {
        guard let routine = routine else { return nil }
        
        if routineHasAnotherWorkout(routine: routine, index: position.workoutIndex) {
            let next = routine.workout[position.workoutIndex]
            position.advanceWorkout()
            currentWorkout = next
        
            return next
        }
        
        return nil
    }

    func numberOfWorkoutsInRoutine() -> Int {
        return routine?.workout.count ?? 0
    }
    
    func restTimeForCurrentWorkout() -> Int {
        return currentWorkout?.rest.value ?? 0
    }
    
    func changeWorkoutPosition(to index:Int){
        guard let routine = routine, let workout = routine.workout[index] as? Workout else { return }
        self.currentWorkout = workout
        self.currentLift = currentWorkout?.lifts.first
        position.hop(to: index)
    }
    
    func isOnFirstWorkout() -> Bool {
        return position.workoutIndex <= 0
    }
    
    private func routineHasAnotherWorkout(routine:Routine, index:Int) -> Bool {
        return routine.workout.endIndex > index
    }
    
    private func workoutHasAnotherLift(workout:Workout, index:Int) -> Bool {
        return workout.lifts.endIndex > index + 1
    }
}

class Position {
    var liftIndex = 1
    var workoutIndex = 1
    
    func hop(to index:Int){
        workoutIndex = index + 1
        liftIndex = 0
    }
    
    func advanceWorkout(){
        workoutIndex += 1
    }
    
    func advanceLift(){
        liftIndex += 1
    }
    
    func resetWorkout(){
        
        workoutIndex = 0
    }
    
    func resetLifts(){
        liftIndex = 0
    }
    
    func coordinates() -> (Int, Int) {
        return (workout: workoutIndex, lift: liftIndex)
    }
}
