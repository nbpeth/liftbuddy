import Foundation

class DateUtils {
    
    static func formatHHMMSS(date:Date) -> String {
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        let hour = String(describing: components.hour ?? 0 )
        let minute = String(describing: components.minute ?? 0 )
        let second = String(describing: components.second ?? 0 )
        
        return "\(hour):\(minute):\(second)"
    }
    
    static func formatMMDDYYYY(date:Date) -> String {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let year = String(describing: components.year ?? 0 )
        let month = String(describing: components.month ?? 0 )
        let day = String(describing: components.day ?? 0 )

        return "\(month)/\(day)/\(year)"
    }
    
    static func differenceBetween(_ startDate:Date, _ endDate:Date) -> DateComponents {
        return Calendar.current.dateComponents([.hour, .minute, .second], from: startDate, to: endDate)
    }
    
    
}
