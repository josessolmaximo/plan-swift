//
//  TaskView.swift
//  Plan
//
//  Created by Joses Solmaximo on 03/11/23.
//

import SwiftUI
import OrderedCollections

struct TaskView: View {
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var taskVM: TaskViewModel
    
    @State var selectedWeek = Date().startOfWeek.startOfDay
    
    @State var weeklyDates: [Date] = [Date().startOfWeek.startOfDay]
    @State var dayDates: [Date] = [Date().startOfWeek.startOfDay]
    
    var orderedTasks: OrderedDictionary<Date, [Task]> {
        let sortedTasks = taskVM.tasks.sorted(by: { $0.startDate ?? Date() > $1.startDate ?? Date() })
        
        var dict: OrderedDictionary<Date, [Task]> = [:]
        
        sortedTasks.forEach { task in
            dict[task.startDate?.startOfDay ?? Date(), default: []].append(task)
        }
        
        return dict
    }
    
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Menu {
                        Picker(selection: $taskVM.taskListMode) {
                            ForEach(TaskListMode.allCases, id: \.self) { mode in
                                Button {
                                    
                                } label: {
                                    Label(mode.displayString, systemImage: mode.icon)
                                }
                            }
                        } label: {
                            EmptyView()
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: taskVM.taskListMode.icon)
                            
                            Text(taskVM.taskListMode.displayString)
                        }
                        .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(.black)
                    
                    Spacer()
                    
                    Menu {
                        Picker(selection: $taskVM.taskListPeriod) {
                            ForEach(TaskListPeriod.allCases, id: \.self) { mode in
                                Button {
                                    
                                } label: {
                                    Text(mode.displayString)
                                }
                            }
                        } label: {
                            EmptyView()
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Text(taskVM.taskListPeriod.displayString)
                            
                            Image(systemName: "calendar.badge.clock")
                        }
                        .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(.black)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                HStack {
                    Text("\(taskVM.selectedDate.formatAs(.MMMM))")
                        .font(.system(size: 17, weight: .semibold))
                }
            }
            
            TabView(selection: $selectedWeek) {
                ForEach(weeklyDates, id: \.self) { weeklyDate in
                    HStack(spacing: 4) {
                        ForEach(Date.array(from: weeklyDate, to: weeklyDate.endOfWeek), id: \.self) { date in
                            Button {
                                withAnimation {
                                    taskVM.selectedDate = date
                                }
                            } label: {
                                VStack(spacing: 4) {
                                    let isToday = date == Date().startOfDay
                                    
                                    if taskVM.taskListPeriod == .month {
                                        Text(date.formatAs(.EEEE).prefix(1))
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(isToday ? .blue : .black)
                                    } else {
                                        Text(date.formatAs(.EEEE).prefix(1))
                                            .font(.system(size: 11, weight: .medium))
                                            .foregroundColor(.gray)
                                        
                                        Text(date.formatAs(.d))
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(isToday ? .blue : .black)
                                    }
                                }
                            }
                            
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 2)
                            .overlay(
                                ZStack {
                                    if taskVM.selectedDate == date {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(uiColor: .systemGray4), lineWidth: 1)
//                                            .foregroundColor(Color.black.opacity(0.025))
                                    }
                                }
                            )
                            .overlay(
                                ZStack {
                                    if let tasks = orderedTasks[date] {
                                        let uncompleted = tasks.contains(where: { !$0.completed })
                                        let allCompleted = !uncompleted
                                        
                                        if uncompleted {
                                            Circle()
                                                .frame(width: 2, height: 2)
                                                .foregroundColor(.gray)
                                                .offset(y: taskVM.taskListPeriod == .month ? 15 : 20)
                                        }
                                    }
                                }
                            )
                        }
                    }
                    .padding(.leading, taskVM.taskListPeriod == .week || taskVM.taskListPeriod == .month ? 48 : 0)
                    .padding(.horizontal, 1)
                    
                    .tag(weeklyDate)
                    .onAppear {
                        if let firstDate = weeklyDates.first, weeklyDate == firstDate {
                            let prevWeek = Calendar.current.date(byAdding: .day, value: -7, to: firstDate)!.startOfDay
                            
                            weeklyDates.insert(prevWeek, at: 0)
                        }
                        
                        if let lastDate = weeklyDates.last, weeklyDate == lastDate {
                            let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: lastDate)!.startOfDay
                            
                            
                            weeklyDates.insert(nextWeek, at: weeklyDates.count)
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 55)
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            if taskVM.taskListMode == .list {
                var dates: [Date] {
                    var dates: [Date] = []
                    var startDate = taskVM.selectedDate.startOfWeek.startOfDay
                    
                    while startDate < taskVM.selectedDate.endOfWeek.endOfDay {
                        dates.append(startDate)
                        startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
                    }
                    
                    return dates
                }
                
                TabView(selection: $taskVM.selectedDate) {
                    ForEach(dates, id: \.self) { date in
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 12) {
                                ForEach(orderedTasks.elements
                                    .filter({
                                        switch taskVM.taskListPeriod {
                                        case .day:
                                            $0.key == date
                                        case .week:
                                            $0.key.isBetween(taskVM.selectedDate.startOfWeek.startOfDay, and: taskVM.selectedDate.endOfWeek.endOfDay)
                                        case .month:
                                            $0.key.isBetween(taskVM.selectedDate.startOfMonth.startOfDay, and: taskVM.selectedDate.endOfMonth.endOfDay)
                                        }
                                    })
                                        .sorted(by: {
                                            $0.key == Date().startOfDay &&
                                            $1.key != Date().startOfDay
                                        }), id: \.key) { key, value in
                                            ForEach(value
                                                .sorted(by: { $0.priorityEnum.rawValue > $1.priorityEnum.rawValue })
                                                .sorted(by: { !$0.completed && $1.completed })) { task in
                                                    TaskRowView(task: task) {
                                                        if let index = taskVM.tasks.firstIndex(where: { $0.id == task.id }) {
                                                            withAnimation {
                                                                taskVM.tasks[index].completed.toggle()
                                                            }
                                                        }
                                                    }
                                                }
                                        }
                            }
                            .padding(.horizontal)
                        }
                        .tag(date)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
        .onAppear {
            let task = Task(context: context)
            task.title = "Wash dishes"
            taskVM.tasks = [task]
        }
    }
}

#Preview {
    TaskView()
        .environmentObject(TaskViewModel())
}
