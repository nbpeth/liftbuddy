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
    
        DispatchQueue.main.async {
            labelToUpdate.text = String(describing: remainingTime )
        }
        
        if remainingTime <= 0 {
            timer.invalidate()
            labelToUpdate.text = "∞"
        }
        
    }
    
    
    func stop(){
        timer?.invalidate()
    }
}

class IncrementingTimer {
    var timer:Timer!
    var timerStartAt:Date?
    
    var labelToUpdate:UILabel?
    
    init(labelToUpdate:UILabel){
        self.labelToUpdate = labelToUpdate
        self.timerStartAt = Date()
    }
    
    func start(){
        timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(updateRestTimer), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc private func updateRestTimer() {
        guard
            let labelToUpdate = labelToUpdate,
            let timerStartAt = timerStartAt
            else { return }
        
        let elapsedTime = DateUtils.differenceBetween(timerStartAt, Date())
        
        guard let hour = elapsedTime.hour, let minute = elapsedTime.minute, let second = elapsedTime.second else { return }
        
        let timeText = "\(ft(hour)):\(ft(minute)):\(ft(second))"
        
        DispatchQueue.main.async {
            labelToUpdate.text = String(describing: timeText )

        }

    }
    
    func ft(_ component:Int) -> String {
        var timeString = String(describing: component)
        
        if component < 10 {
//            timeString.insert("0", )
            timeString = "0\(String(describing: component))"
        }
        
       
      
        return timeString
    }
    
    
    func stop(){
        timer?.invalidate()
    }
}
