import Foundation
import RealmSwift

class RoutineRunner {
    var routine:RoutineInProgress?
    var currentWorkout:WorkoutInProgress?
    var currentLift:LiftInProgress?
    var previousLift:LiftInProgress?
    var timer: Timer?
    var position = Position()
    
    init(routine:RoutineInProgress){
        self.routine = routine
        self.currentWorkout = routine.workout.first
        self.currentLift = getFirstLiftOfWorkout()
        
    }
    
    func getFirstLiftOfWorkout() -> LiftInProgress? {
        return currentWorkout?.lifts.first
    }
    
    func completeLift() {
        currentLift?.completed = true
    }
    
    func nextLiftSet() {
        guard let currentWorkout = currentWorkout else { return  }
        completeLift()
        position.advanceLift()
        
        if(currentWorkout.lifts.count <= position.liftIndex){
            position.resetLifts()
            self.currentWorkout = nextWorkout()
        }
        
        guard let currentWorkoutLifts = self.currentWorkout?.lifts else { return }
        if currentWorkoutLifts.count > 0 {
            self.currentLift = currentWorkoutLifts[position.liftIndex]
        }
    }
    
    private func nextWorkout() -> WorkoutInProgress? {
        guard let routine = routine else { return nil }
        
        position.advanceWorkout()

        if routineHasAnotherWorkout(routine: routine, index: position.workoutIndex) {
            let next = routine.workout[position.workoutIndex]
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
    
    func changeWorkoutPosition(to workoutIndex:Int, liftIndex:Int){
        guard let routine = routine else { return }
        self.currentWorkout = routine.workout[workoutIndex]
        self.currentLift = currentWorkout?.lifts[liftIndex]
        
        position.hop(to: workoutIndex, liftIndex: liftIndex)
    }
    
    func isOnFirstWorkout() -> Bool {
        return position.workoutIndex <= 0
    }
    
    func isOnLastLiftOfLastWorkout() -> Bool {
        guard let routine = routine else { return true }
        
        if routine.workout.count < 1 {
            return true
        }
        
        let lastWorkoutPosition = routine.workout.count > 0 ? routine.workout.count - 1 : 0
        let lastWorkout = routine.workout[lastWorkoutPosition]
        let lastLiftPosition = lastWorkout.lifts.count > 0 ? lastWorkout.lifts.count - 1 : 0
    
        return (position.workoutIndex >= routine.workout.count - 1) && (position.liftIndex >= lastLiftPosition)
    }
    
    func skipRest() -> Bool {
        guard let currentWorkout = currentWorkout,
            let rest = currentWorkout.rest.value
            else { return true }
        
        return rest <= 0
    }
    
    private func routineHasAnotherWorkout(routine:RoutineInProgress, index:Int) -> Bool {
        return routine.workout.count > index
    }
    
    private func workoutHasAnotherLift(workout:WorkoutInProgress, index:Int) -> Bool {
        return workout.lifts.count > index
    }
}

class Position {
    var liftIndex = 0
    var workoutIndex = 0
    
    func hop(to workoutIndex:Int, liftIndex:Int){
        self.workoutIndex = workoutIndex
        self.liftIndex = liftIndex
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
