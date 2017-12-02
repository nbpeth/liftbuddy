import UIKit

class RestTimer {
    var timer:Timer!
    var restTime = 0
    var delegate:UIViewController!
    
    init(delegate:UIViewController, rest:Int){
        self.delegate = delegate
        self.restTime = rest
    }
    
    @objc private func updateRestTimer() {
        guard let delegate = delegate as? RoutineRunnerViewController else { return }
        
        delegate.nameLabel.text = String(describing: restTime )
        
        if restTime > 0 {
            restTime -= 1
        }
        else{
            timer.invalidate()
            delegate.nameLabel.text = String(describing: restTime )
        }
    }
    
    func fireRestTimer(){
        guard let delegate = delegate as? RoutineRunnerViewController else { return }
        
        restTime = delegate.runner?.restTimeForCurrentWorkout() ?? 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateRestTimer), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    func stop(){
        timer?.invalidate()
    }
}
