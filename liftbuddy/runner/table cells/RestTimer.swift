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
        guard let delegate = delegate as? RestViewController else { return }
        
        delegate.restLabel.text = String(describing: restTime )
        
        if restTime > 0 {
            restTime -= 1
        }
        else{
            timer.invalidate()
            delegate.restLabel.text = String(describing: restTime )
            delegate.dismiss(animated: true, completion: nil)
        }
    }
    
    func fireRestTimer(){
        guard let delegate = delegate as? RestViewController else { return }
        
        restTime = 0
        restTime = delegate.restTime
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateRestTimer), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    func stop(){
        timer?.invalidate()
    }
}
