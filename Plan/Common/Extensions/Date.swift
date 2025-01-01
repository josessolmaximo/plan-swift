//
//  Date.swift
//  Plan
//
//  Created by Joses Solmaximo on 06/11/23.
//

import Foundation

extension Date {
    func formatAs(_ format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
    
    enum DateFormat: String {
        case Hmm = "H:mm"
        case d_MMMM = "d MMMM"
        case d = "d"
        case EEEE = "EEEE"
        case H = "H"
        case h_a = "h a"
        case MMMM = "MMMM"
        case dMMMMyyyy = "d MMMM yyyy"
        case h_mma = "h:mm a"
    }
    
    var ordinalDate: String {
        let ordinalFormatter = NumberFormatter()
        ordinalFormatter.numberStyle = .ordinal
        let day = Calendar.current.component(.day, from: self)
        let dayOrdinal = ordinalFormatter.string(from: NSNumber(value: day))!
        return dayOrdinal
    }
    
    static func random(from startDate: Int, to endDate: Int) -> Date {
        let date1 = Calendar.current.date(byAdding: .day, value: startDate, to: .now)!
        let date2 = Calendar.current.date(byAdding: .day, value: endDate, to: .now)!
        
        let startTime = date1.timeIntervalSince1970
        let endTime = date2.timeIntervalSince1970
        
        let randomDate = TimeInterval.random(in: startTime...endTime)
        return Date(timeIntervalSince1970: randomDate)
    }
}

extension Date {
    var startOfMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    var endOfMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }
    
    var startOfDay: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    var endOfDay: Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
    
    var startOfWeek: Date {
        let calendar = Calendar.current
        
        let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        
        return calendar.date(byAdding: .day, value: 0, to: sunday!)!
    }
    
    var endOfWeek: Date {
        let calendar = Calendar.current
        
        let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        
        return calendar.date(byAdding: .day, value: 6, to: sunday!)!
    }
    
    var startOfYear: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: self)))!
    }
    
    var endOfYear: Date {
        return Calendar.current.date(bySetting: .month, value: 12, of: self.startOfYear)!
    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    func overlapsWith(_ date1: Date, and date2: Date) -> Bool {
        return min(date1, date2) <= self && max(date1, date2) >= self
    }
    
    static func array(from startDate: Date, to endDate: Date) -> [Date] {
        var startDate = startDate
        let endDate = endDate
        
        var dates: [Date] = []
        
        while startDate <= endDate {
            dates.append(startDate)
            
            startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        }
        
        return dates
    }
}

extension ClosedRange where Bound == Date {
    func overlaps(_ range2: ClosedRange<Date>) -> Bool {
        return self.lowerBound < range2.upperBound && self.upperBound > range2.lowerBound
    }
}
