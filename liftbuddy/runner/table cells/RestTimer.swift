import UIKit

class CustomTimer {
    
    var timer:Timer!

    func ft(_ component:Int) -> String {
        var timeString = String(describing: component)
        
        if component < 10 {
            timeString = "0\(String(describing: component))"
        }
        
        return timeString
    }
    
    func stop(){
        timer?.invalidate()
    }
}

class RestTimer:CustomTimer {
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
            let timeToStopTimer = timeToStopTimer
        else { return }
        
        let remainingTime = DateUtils.differenceBetween(Date(), timeToStopTimer)

        guard let minute = remainingTime.minute,
            let second = remainingTime.second
        else { return }
   
        
        let timeText = "\((minute)):\(ft(second))"
        
        labelToUpdate.text = timeText
        
        
        if minute <= 0 && second <= 0 {
            timer.invalidate()
            labelToUpdate.text = "∞"
        }
        
    }
}

class IncrementingTimer: CustomTimer {
    static let shared = IncrementingTimer()

    var timerStartAt:Date?
    var labelToUpdate:UILabel?
    
    func start(labelToUpdate:UILabel){
        self.timerStartAt = Date()
        self.labelToUpdate = labelToUpdate
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
}
