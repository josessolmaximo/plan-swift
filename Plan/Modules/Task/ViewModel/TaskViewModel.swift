//
//  TaskViewModel.swift
//  Plan
//
//  Created by Joses Solmaximo on 06/11/23.
//

import Foundation

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var tags: [String: String] = [:]
    
    @Published var taskListMode: TaskListMode = .list
    @Published var taskListPeriod: TaskListPeriod = .day
    
    @Published var startDate = Date().startOfWeek.startOfDay
    @Published var endDate = Date().endOfWeek.startOfDay
    
    @Published var selectedDate = Date().startOfDay
    
}
