//
//  Task+CoreDataClass.swift
//  Plan
//
//  Created by Joses Solmaximo on 10/02/24.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {
    var typeEnum: TaskType {
        get { return TaskType(rawValue: self.type) ?? .task }
        set { self.type = newValue.rawValue }
    }
    
    var priorityEnum: Priority {
        get { return Priority(rawValue: self.priority) ?? .none }
        set { self.priority = newValue.rawValue }
    }
    
    var repetition: Repetition {
        get {
            let period = Repetition.Period(rawValue: repetitionPeriod) ?? .day
            let repeatFrom = Repetition.RepeatFrom(rawValue: repetitionPeriod) ?? .lastDue
            
            return Repetition(
                amount: repetitionAmount,
                periodAmount: repetitionPeriodAmount,
                period: period,
                repeatTime: repetitionRepeatTime ?? Date(),
                repeatFrom: repeatFrom,
                weekdays: repetitionWeekdays ?? []
            ) }
        
        set { 
            self.repetitionAmount = newValue.amount
            self.repetitionPeriodAmount = newValue.periodAmount
            self.repetitionPeriod = newValue.period.rawValue
            self.repetitionRepeatTime = newValue.repeatTime
            self.repetitionWeekdays = newValue.weekdays
            self.repetitionRepeatFrom = newValue.repeatFrom.rawValue
        }
    }
    
    var goal: Goal {
        get {
            let period = Goal.Period(rawValue: goalPeriod) ?? .day
            let subunit = Subunit(rawValue: goalSubunit) ?? .time
            
            return Goal(amount: goalAmount, period: period, subunit: subunit)
        }
        
        set {
            self.goalAmount = newValue.amount
            self.goalPeriod = newValue.period.rawValue
            self.goalSubunit = newValue.subunit.rawValue
        }
    }
    
    var reminder: Reminder {
        get {
            return Reminder(delay: reminderDelay, time: reminderTime ?? Date(), weekdays: reminderWeekdays ?? [])
        }
        
        set {
            self.reminderDelay = newValue.delay
            self.reminderTime = newValue.time
            self.reminderWeekdays = newValue.weekdays
        }
    }
}
