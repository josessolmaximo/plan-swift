//
//  Task+CoreDataProperties.swift
//  Plan
//
//  Created by Joses Solmaximo on 10/02/24.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var type: Int16
    @NSManaged public var title: String?
    @NSManaged public var note: String?
    @NSManaged public var date: Date?
    @NSManaged public var color: String?
    @NSManaged public var image: String?
    @NSManaged public var priority: Int16
    @NSManaged public var tags: [String]?
    @NSManaged public var completed: Bool
    @NSManaged public var completionAmount: Int64
    @NSManaged public var assignees: [String]?
    @NSManaged public var completedOn: [Date]?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var startTime: Date?
    @NSManaged public var endTime: Date?
    @NSManaged public var createdOn: Date?
    @NSManaged public var createdBy: String?
    @NSManaged public var goalAmount: Int64
    @NSManaged public var goalPeriod: Int16
    @NSManaged public var goalSubunit: Int16
    @NSManaged public var reminderDelay: Int64
    @NSManaged public var reminderTime: Date?
    @NSManaged public var reminderWeekdays: [Int64]?
    @NSManaged public var repetitionAmount: Int64
    @NSManaged public var repetitionPeriodAmount: Int64
    @NSManaged public var repetitionPeriod: Int16
    @NSManaged public var repetitionRepeatTime: Date?
    @NSManaged public var repetitionRepeatFrom: Int16
    @NSManaged public var repetitionWeekdays: [Int64]?
    @NSManaged public var subtask: NSSet?

}

// MARK: Generated accessors for subtask
extension Task {

    @objc(addSubtaskObject:)
    @NSManaged public func addToSubtask(_ value: Subtask)

    @objc(removeSubtaskObject:)
    @NSManaged public func removeFromSubtask(_ value: Subtask)

    @objc(addSubtask:)
    @NSManaged public func addToSubtask(_ values: NSSet)

    @objc(removeSubtask:)
    @NSManaged public func removeFromSubtask(_ values: NSSet)

}

extension Task : Identifiable {

}
