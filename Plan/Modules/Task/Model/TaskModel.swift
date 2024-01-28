//
//  TaskModel.swift
//  Plan
//
//  Created by Joses Solmaximo on 03/11/23.
//

import SwiftUI

struct Task: Codable, Identifiable, Hashable {
    var id = UUID()
    var title: String = ""
    var description: String = ""
    var priority: Priority = .none
    var tags: [String] = []
    var completed: Bool = false
    var assignees: [String] = []
    var subtasks: [Subtask] = []
    var startDate: Date = Date()
    var endDate: Date? = nil
    var startTime: Date? = nil
    var endTime: Date? = nil
    var repetition: Repetition?
    var createdOn: Date = Date()
    var createdBy: String?
    
    struct Repetition: Codable, Hashable {
        var amount: Int
        var periodAmount: Int
        var period: Period
        
        enum Period: Codable, Hashable {
            case hour
            case day
            case week
            case month
        }
    }
    
    enum Priority: Int, Codable, CaseIterable, Hashable {
        case high = 3
        case medium = 2
        case low = 1
        case none = 0
        
        var color: Color {
            switch self {
            case .high:
                return .red
            case .medium:
                return .orange
            case .low:
                return .blue
            case .none:
                return .gray
            }
        }
    }
    
    struct Subtask: Codable, Identifiable, Hashable {
        var id = UUID()
        var title: String = ""
        var description: String = ""
        var completed: Bool = false
    }
}

extension Task {
    static func randomTasks(_ amount: Int) -> [Task] {
        let titles = [
            "Buy groceries for the week",
            "Complete a 30-minute workout",
            "Schedule a dentist appointment",
            "Read a chapter from your current book",
            "Write a thank-you note to a friend",
            "Organize your closet and donate unused clothes",
            "Pay the monthly utility bills",
            "Plan a weekend outing with friends",
            "Research and book a vacation",
            "Finish a work presentation",
            "Water the houseplants",
            "Call your parents to catch up",
            "Create a shopping list for a home improvement project",
            "Sort through and organize your email inbox",
            "Set up a meeting with a colleague to discuss a project",
            "Declutter and clean the garage",
            "Update your resume",
            "Start a new hobby or craft project",
            "Meal prep for the week",
            "Learn a new recipe and cook dinner for the family",
        ]
        
        let descriptions = [
            "Make a list of essential food items and head to the store to restock your kitchen",
            "Dedicate some time to exercise to stay healthy and fit. Choose your favorite workout routine or try something new",
            "Take care of your dental health by calling your dentist's office to set up your next checkup",
            "Set aside some quiet time to immerse yourself in the world of your current book and make progress in your reading",
            "Show your appreciation by writing a heartfelt note to a friend who has done something kind for you",
            "Declutter your closet, sort through your clothes, and donate any items you no longer need to help others in need",
            "Ensure your household bills are up to date by paying your monthly utility bills",
            "Organize a fun and memorable weekend activity with your friends to spend quality time together",
            "Start planning your dream vacation by researching destinations, accommodations, and activities. Once you're ready, make a reservation",
            "Put the final touches on an important work presentation to ensure it's polished and ready for your audience",
            "Give your indoor plants the care they need by watering them according to their specific requirements",
            "Take a moment to connect with your parents, share updates, and have a meaningful conversation",
            "Plan ahead by listing the materials and tools you need for your upcoming home improvement project",
            "Tackle your email clutter by categorizing, archiving, or deleting old emails for a cleaner inbox",
            "Coordinate with a colleague to schedule a meeting where you can collaborate and discuss a work project",
            "Dedicate some time to organizing and cleaning your garage space, making it more functional and organized",
            "Review and update your resume with your latest achievements and experiences to be prepared for new job opportunities",
            "Begin a new creative endeavor or hobby that you've been interested in, whether it's painting, knitting, or learning a musical instrument",
            "Save time and eat healthier by preparing your meals for the upcoming week in advance",
            "Experiment in the kitchen by trying out a new recipe and cooking a delicious meal for your family or loved ones",
        ]
        
        let assignees = [
            "Jasper",
            "Elowen",
            "Bennett",
            "Seraphina",
            "Orion",
            "Lillian",
            "Atticus",
            "Isolde",
            "Silas",
            "Calliope",
            "Lucian",
            "Serenity",
            "Rowan",
            "Aurora",
            "Zephyr",
            "Celeste",
            "Finnian",
            "Elysia",
            "Thaddeus",
            "Ophelia",
        ]
        
        return (0..<amount).map { _ in
            let startDate = Date.random(from: -3, to: 3)
            let startTime = Date.random(from: -3, to: 3)
            
            return Task(
                title: titles.randomElement() ?? "",
                description: descriptions.randomElement() ?? "",
                priority: Bool.random() ? Task.Priority.allCases.randomElement() ?? .none: .none,
                tags: (0..<Int.random(in: 0...3)).map({ _ in allTags.randomElement()?.0 ?? "" }),
                completed: Bool.random(),
                assignees: Bool.random() ? (0..<Int.random(in: 0...3)).map({ _ in assignees.randomElement() ?? "" }): [],
                subtasks: Bool.random() ? Task.Subtask.randomTasks(Int.random(in: 0...5)) : [],
                startDate: startDate,
                endDate: Bool.random() ? startDate.advanced(by: .random(in: 0...10000)) : nil,
                startTime: Bool.random() ? startTime : nil,
                endTime: Bool.random() ? startTime.advanced(by: .random(in: 0...30000)) : nil,
                createdOn: Date(),
                createdBy: nil
            )
        }
    }
}


extension Task.Subtask {
    static func randomTasks(_ amount: Int) -> [Task.Subtask] {
        let titles = [
            "Buy groceries for the week",
            "Complete a 30-minute workout",
            "Schedule a dentist appointment",
            "Read a chapter from your current book",
            "Write a thank-you note to a friend",
            "Organize your closet and donate unused clothes",
            "Pay the monthly utility bills",
            "Plan a weekend outing with friends",
            "Research and book a vacation",
            "Finish a work presentation",
            "Water the houseplants",
            "Call your parents to catch up",
            "Create a shopping list for a home improvement project",
            "Sort through and organize your email inbox",
            "Set up a meeting with a colleague to discuss a project",
            "Declutter and clean the garage",
            "Update your resume",
            "Start a new hobby or craft project",
            "Meal prep for the week",
            "Learn a new recipe and cook dinner for the family",
        ]
        
        let descriptions = [
            "Make a list of essential food items and head to the store to restock your kitchen",
            "Dedicate some time to exercise to stay healthy and fit. Choose your favorite workout routine or try something new",
            "Take care of your dental health by calling your dentist's office to set up your next checkup",
            "Set aside some quiet time to immerse yourself in the world of your current book and make progress in your reading",
            "Show your appreciation by writing a heartfelt note to a friend who has done something kind for you",
            "Declutter your closet, sort through your clothes, and donate any items you no longer need to help others in need",
            "Ensure your household bills are up to date by paying your monthly utility bills",
            "Organize a fun and memorable weekend activity with your friends to spend quality time together",
            "Start planning your dream vacation by researching destinations, accommodations, and activities. Once you're ready, make a reservation",
            "Put the final touches on an important work presentation to ensure it's polished and ready for your audience",
            "Give your indoor plants the care they need by watering them according to their specific requirements",
            "Take a moment to connect with your parents, share updates, and have a meaningful conversation",
            "Plan ahead by listing the materials and tools you need for your upcoming home improvement project",
            "Tackle your email clutter by categorizing, archiving, or deleting old emails for a cleaner inbox",
            "Coordinate with a colleague to schedule a meeting where you can collaborate and discuss a work project",
            "Dedicate some time to organizing and cleaning your garage space, making it more functional and organized",
            "Review and update your resume with your latest achievements and experiences to be prepared for new job opportunities",
            "Begin a new creative endeavor or hobby that you've been interested in, whether it's painting, knitting, or learning a musical instrument",
            "Save time and eat healthier by preparing your meals for the upcoming week in advance",
            "Experiment in the kitchen by trying out a new recipe and cooking a delicious meal for your family or loved ones",
        ]
        
        return (0..<amount).map { _ in
            return Task.Subtask(
                title: titles.randomElement() ?? "",
                description: descriptions.randomElement() ?? "",
                completed: Bool.random()
            )
        }
    }
}

enum TaskListMode: String, CaseIterable {
    case list
    case timeline
    
    var icon: String {
        switch self {
        case .list:
            return "list.bullet.below.rectangle"
        case .timeline:
            return "calendar.day.timeline.left"
        }
    }
    
    var displayString: String {
        switch self {
        case .list:
            return "List"
        case .timeline:
            return "Timeline"
        }
    }
}

enum TaskListPeriod: String, CaseIterable {
    case day
    case week
    case month
    
    var displayString: String {
        switch self {
        case .day:
            return "Day"
        case .week:
            return "Week"
        case .month:
            return "Month"
        }
    }
}

let allTags: [(String, String)] = [
    ("Food", "fork.knife"),
    ("Groceries", "cart"),
    ("Exercise", "dumbbell"),
    ("Health", "staroflife"),
    ("Work", "briefcase"),
    ("Personal", "person"),
    ("Family", "figure.2.and.child.holdinghands"),
    ("Friends", "person.2"),
    ("Cooking", "frying.pan"),
    ("Shopping", "bag"),
    ("Fitness", "figure.walk"),
    ("Reading", "text.book.closed"),
    ("Entertainment", "gamecontroller"),
    ("Hobby", "camera"),
    ("Cleaning", "trash"),
]
