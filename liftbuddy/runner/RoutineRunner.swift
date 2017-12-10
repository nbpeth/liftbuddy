import Foundation
import RealmSwift

class RoutineRunner {
    
//    var routine:Routine?
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
    
    func nextLiftSet() {
        guard let currentWorkout = currentWorkout else { return  }
        
        position.advanceLift()
        
        if(currentWorkout.lifts.count <= position.liftIndex){
            position.resetLifts()
            self.currentWorkout = nextWorkout()
        
        }
        
        self.currentLift = self.currentWorkout?.lifts[position.liftIndex]
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
    
    func changeWorkoutPosition(to index:Int){
        guard let routine = routine, let workout = routine.workout[index] as? WorkoutInProgress else { return }
        self.currentWorkout = workout
        self.currentLift = currentWorkout?.lifts.first
        
        position.hop(to: index)
    }
    
    func isOnFirstWorkout() -> Bool {
        return position.workoutIndex <= 0
    }
    
    func isOnLastLiftOfLastWorkout() -> Bool {
        guard let routine = routine else { return true }
        let lastWorkout = routine.workout[routine.workout.count - 1]
    
        return (position.workoutIndex >= routine.workout.count - 1) && (position.liftIndex >= lastWorkout.lifts.count - 1)
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
    
    func hop(to index:Int){
        workoutIndex = index
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
