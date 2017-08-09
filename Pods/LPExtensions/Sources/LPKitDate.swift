//
//  LPKitDate.swift
//  LPExtensions
//
//  Created by Guo Zhiqiang on 16/11/8.
//  Copyright © 2016年 Guo Zhiqiang. All rights reserved.
//

import Foundation

/// Extends the usual date specifications
public extension Date {
    func formatTimeList() -> String {
        var timestamp:String
        var now:time_t = time_t()
        time(&now)
        
        var distance = Int(difftime(now, time_t(timeIntervalSince1970)))
        if distance < 0 {
            distance = 0
        }
        
        if (distance < 60) {
            timestamp = "\(distance)秒前"
        } else if distance < 60 * 60 {
            distance = distance / 60
            timestamp = "\(distance)分钟前"
        } else if distance < 60 * 60 * 24 {
            distance = distance / 60 / 60
            timestamp = "\(distance)小时前"
        } else if distance < 60 * 60 * 24 * 7 {
            distance = distance / 60 / 60 / 24
            timestamp = "\(distance)天前"
        } else if distance < 60 * 60 * 24 * 7 * 4 {
            distance = distance / 60 / 60 / 24 / 7
            timestamp = "\(distance)周前"
        } else {
            timestamp = formatTime(format: "M月d日 HH:mm")
        }
        return timestamp
    }
    
    func formatTimeWithWeekdays() -> String {
        return formatTime(format: "yy.MM.dd EEEE")
    }
    
    func formatTime(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
        return dateFormatter.string(from: date)
    }
    
    func formatTimeYMD() -> String {
        return formatTime(format: "yyyy-MM-dd")
    }
    
    func formatTimeYMDHMS() -> String {
        return formatTime(format: "yyyy-MM-dd HH:mm:ss")
    }
    
    func formatTimeYMDHM() -> String {
        return formatTime(format: "yyyy-MM-dd HH:mm")
    }
    
    func formatTimeMD() -> String {
        return formatTime(format: "MM月dd日")
    }
    
    func formatRemainingTime() -> String {
        var timestamp = ""
        var now:time_t = time_t()
        time(&now)
        
        let distance = Int(difftime(time_t(timeIntervalSince1970), now))
        
        let mimute = 60
        let hour = mimute * 60
        let day = hour * 24
        
        let intervaDays = distance / day
        if intervaDays > 0 {
            timestamp = "\(intervaDays)天"
        } else if intervaDays <= 0 {
            timestamp = "到期"
        }
        
        return timestamp
    }
    
    func years(since date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let earlyDate = min(self, date)
        let laterDate = max(self, date)
        let sign = earlyDate == self ? -1 : 1
        let components = calendar.dateComponents([.year], from: earlyDate, to: laterDate)
        
        return sign * (components.year ?? 0)
    }
    
    func years(before date: Date) -> Int {
        return -years(since: date)
    }

}
