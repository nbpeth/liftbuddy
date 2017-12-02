import UIKit

class RestTimer {
    var timer:Timer!
    var restTime = 0
    var initialRest = 0
    var delegate:UIViewController!
    
    init(delegate:UIViewController, rest:Int){
        self.delegate = delegate
        self.restTime = rest
        self.initialRest = rest
    }
    
    @objc private func updateRestTimer() {
        guard let delegate = delegate as? RestViewController else { return }
        
        delegate.restLabel.text = String(describing: restTime )
        
        if restTime > 0 {
            restTime -= 1
            updateProgressView()
        }
        else{
            timer.invalidate()
            delegate.restLabel.text = String(describing: restTime )
            delegate.dismiss(animated: true, completion: nil)
        }
    }
    
    func updateProgressView(){
        guard let delegate = delegate as? RestViewController else { return }
        
        
        delegate.progressView.setProgress(Float(restTime) / Float(initialRest), animated: true)
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
