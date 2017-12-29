import UIKit

class RestTimer {
    var timer:Timer!
    var timeToStopTimer:Date?

    var labelToUpdate:UILabel?
    
    init(labelToUpdate:UILabel, rest:Int){
        self.labelToUpdate = labelToUpdate
        self.timeToStopTimer = Calendar.current.date(byAdding: .second, value: rest, to: Date())

    }
    
    func fireRestTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(updateRestTimer), userInfo: nil, repeats: true)
        
        timer?.fire()
    }
    
    @objc private func updateRestTimer() {
        guard
            let labelToUpdate = labelToUpdate,
            let timeToStopTimer = timeToStopTimer,
            let remainingTime = DateUtils.differenceBetween(Date(), timeToStopTimer).second
        else { return }
    
        labelToUpdate.text = String(describing: remainingTime )
        
        if remainingTime <= 0 {
            timer.invalidate()
            labelToUpdate.text = "∞"
        }
    }
    
    
    func stop(){
        timer?.invalidate()
    }
}
