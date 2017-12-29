import UIKit

class RestTimer {
    var timer:Timer!
    var timeToStopTimer:Date?

    var delegate:UIViewController!
    
    init(delegate:UIViewController, rest:Int){
        self.delegate = delegate
        self.timeToStopTimer = Calendar.current.date(byAdding: .second, value: rest, to: Date())

    }
    
    func fireRestTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateRestTimer), userInfo: nil, repeats: true)
        
        timer?.fire()
    }
    
    @objc private func updateRestTimer() {
        guard let delegate = delegate as? RoutineRunnerViewController,
            let timeToStopTimer = timeToStopTimer,
            let remainingTime = DateUtils.differenceBetween(Date(), timeToStopTimer).second
        else { return }
        
    
        delegate.restTimerLabel.text = String(describing: remainingTime )
        
        if remainingTime <= 0 {
            timer.invalidate()
            delegate.restTimerLabel.text = String(describing: remainingTime )
        }
    }
    
    
    func stop(){
        timer?.invalidate()
    }
}
