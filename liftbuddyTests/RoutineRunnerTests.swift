import XCTest
import Foundation
import RealmSwift
@testable import liftbuddy

class RoutineRunnerTests: XCTestCase {

    func testCanGetFirstLiftOfWorkout() {
        let routine = testRoutine()
        
        routine.workout.append(buildWorkout(name: "get jacked", numberOfLifts: 1))
        
        let runner = RoutineRunner(routine:routine)
        
        assert(runner.getFirstLiftOfWorkout()?.name == "get jacked_1" )
        
    }
    
    func testCanGetNextLiftFromWorkoutWhenAnotherLiftIsAvailable(){
        let routine = testRoutine()
        routine.workout.append(buildWorkout(name: "get jacked", numberOfLifts: 3))

        let runner = RoutineRunner(routine:routine)
        
        assert(runner.position.coordinates() == (0,0))
        assert(runner.currentLift?.name == "get jacked_1")

        runner.nextLiftSet()
        
        assert(runner.position.coordinates() == (0,1))
        assert(runner.currentLift?.name == "get jacked_2")
        
        runner.nextLiftSet()
        
        assert(runner.position.coordinates() == (0,2))
        assert(runner.currentLift?.name == "get jacked_3")

    }
    
    func testCanGetNextWorkoutFromRoutineWhenNoMoreLiftsAvailableInCurrentWorkout(){
        let routine = testRoutine()
        routine.workout.append(buildWorkout(name: "get jacked", numberOfLifts: 1))
        routine.workout.append(buildWorkout(name: "too tired", numberOfLifts: 1))

        let runner = RoutineRunner(routine:routine)
        
        assert(runner.position.coordinates() == (0,0))

        runner.nextLiftSet()
        
        assert(runner.position.coordinates() == (1,0))
        assert(runner.currentLift?.name == "too tired_1")
    }
    
    func testCanSequentiallyMoveThroughARoutine(){
        let routine = testRoutine()
        routine.workout.append(buildWorkout(name: "get jacked", numberOfLifts: 2))
        routine.workout.append(buildWorkout(name: "too tired", numberOfLifts: 3))
        routine.workout.append(buildWorkout(name: "stop it", numberOfLifts: 2))

        let runner = RoutineRunner(routine:routine)
        
        assert(runner.position.coordinates() == (0,0))
        assert(runner.currentLift?.name == "get jacked_1")
        assert(!runner.isOnLastLiftOfLastWorkout())
        
        runner.nextLiftSet()
        
        assert(runner.position.coordinates() == (0,1))
        assert(runner.currentLift?.name == "get jacked_2")
        assert(!runner.isOnLastLiftOfLastWorkout())

        runner.nextLiftSet()
        
        assert(runner.position.coordinates() == (1,0))
        assert(runner.currentLift?.name == "too tired_1")
        assert(!runner.isOnLastLiftOfLastWorkout())
        
        runner.nextLiftSet()
        
        assert(runner.position.coordinates() == (1,1))
        assert(runner.currentLift?.name == "too tired_2")
        assert(!runner.isOnLastLiftOfLastWorkout())
        
        runner.nextLiftSet()
        
        assert(runner.position.coordinates() == (1,2))
        assert(runner.currentLift?.name == "too tired_3")
        assert(!runner.isOnLastLiftOfLastWorkout())

        runner.nextLiftSet()
        
        assert(runner.position.coordinates() == (2,0))
        assert(runner.currentLift?.name == "stop it_1")
        assert(!runner.isOnLastLiftOfLastWorkout())
        
        runner.nextLiftSet()
        
        assert(runner.position.coordinates() == (2,1))
        assert(runner.currentLift?.name == "stop it_2")
        assert(runner.isOnLastLiftOfLastWorkout())
    }
    
    func testCanHopBackToAWorkout(){
        let routine = testRoutine()
        routine.workout.append(buildWorkout(name: "get jacked", numberOfLifts: 1))
        routine.workout.append(buildWorkout(name: "too tired", numberOfLifts: 1))

        let runner = RoutineRunner(routine:routine)
        runner.nextLiftSet()
        
        assert(runner.position.coordinates() == (1,0))

        runner.changeWorkoutPosition(to: 0)
        
        assert(runner.position.coordinates() == (0,0))

    }
    
    func testCanHopForwardToAWorkout(){
        let routine = testRoutine()
        routine.workout.append(buildWorkout(name: "get jacked", numberOfLifts: 1))
        routine.workout.append(buildWorkout(name: "too tired", numberOfLifts: 1))
        routine.workout.append(buildWorkout(name: "dog toss", numberOfLifts: 2))

        let runner = RoutineRunner(routine:routine)
        
        assert(runner.position.coordinates() == (0,0))
        
        runner.changeWorkoutPosition(to: 2)
        
        assert(runner.position.coordinates() == (2,0))
        
    }
    
    func testCanHopBackToAWorkoutAndResumeWithoutInterruption(){
        let routine = testRoutine()
        routine.workout.append(buildWorkout(name: "get jacked", numberOfLifts: 1))
        routine.workout.append(buildWorkout(name: "too tired", numberOfLifts: 2))
        routine.workout.append(buildWorkout(name: "dog toss", numberOfLifts: 2))
        
        let runner = RoutineRunner(routine:routine)
        runner.nextLiftSet()
        
        assert(runner.position.coordinates() == (1,0))
        assert(!runner.isOnLastLiftOfLastWorkout())
        
        runner.changeWorkoutPosition(to: 0)
        
        assert(runner.position.coordinates() == (0,0))
        assert(!runner.isOnLastLiftOfLastWorkout())
        
        runner.nextLiftSet()

        assert(runner.position.coordinates() == (1,0))
        assert(!runner.isOnLastLiftOfLastWorkout())
        
        runner.nextLiftSet()
        
        assert(runner.position.coordinates() == (1,1))
        assert(!runner.isOnLastLiftOfLastWorkout())
        
        runner.nextLiftSet()
        
        assert(runner.position.coordinates() == (2,0))
        assert(!runner.isOnLastLiftOfLastWorkout())
        
        runner.nextLiftSet()
        
        assert(runner.position.coordinates() == (2,1))
        assert(runner.isOnLastLiftOfLastWorkout())
    }
    
    private func testRoutine() -> RoutineInProgress {
        let routine = RoutineInProgress()
        routine.workout = List<WorkoutInProgress>()
        return routine
    }
    
    private func buildWorkout(name:String, numberOfLifts:Int) -> WorkoutInProgress {
        let workout = WorkoutInProgress()
        workout.name = name

        let lifts = List<LiftInProgress>()
        
        for i in 1 ... numberOfLifts {
            lifts.append(LiftInProgress(name: String(describing:"\(name)_\(i)")))
        }
        
        workout.lifts = lifts
        
        return workout
    }
}

