//
//  TaskView.swift
//  Plan
//
//  Created by Joses Solmaximo on 03/11/23.
//

import SwiftUI
import OrderedCollections

struct TaskView: View {
    @StateObject var taskVM = TaskViewModel()
    
    @State var selectedWeek = Date().startOfWeek.startOfDay
    
    @State var weeklyDates: [Date] = [Date().startOfWeek.startOfDay]
    @State var dayDates: [Date] = [Date().startOfWeek.startOfDay]
    
    var orderedTasks: OrderedDictionary<Date, [Task]> {
        let sortedTasks = taskVM.tasks.sorted(by: { $0.startDate > $1.startDate })
        
        var dict: OrderedDictionary<Date, [Task]> = [:]
        
        sortedTasks.forEach { task in
            dict[task.startDate.startOfDay, default: []].append(task)
        }
        
        return dict
    }
    
    var taskSlots: OrderedDictionary<String, (width: Double, offset: Double)> {
        let tasks = orderedTasks.elements
            .filter({
                $0.key == Date().startOfDay
            })
            .map({ $0.value })
            .reduce([], +)
            .filter({ $0.startTime != nil && $0.endTime != nil })
            .sorted(by: {
                if let start1 = $0.startTime, let start2 = $1.startTime {
                    if let end1 = $0.endTime, let end2 = $1.endTime {
                        let duration1 = end1.distance(to: start1)
                        let duration2 = end2.distance(to: start2)
                        
                        return duration1 < duration2 && start1 < start2
                    }
                    
                    return start1 < start2
                } else {
                    return false
                }
            })
            
        
        var slots: OrderedDictionary<String, (width: Double, offset: Double)> = [:]
        
        var overlaps: OrderedDictionary<String, [Task]> = [:]
        
        tasks.forEach { task in
            let index = tasks.firstIndex(of: task)
            
            overlaps[task.id.uuidString] = findOverlappingTasks(task.startTime!...task.endTime!, tasks: tasks)
        }
        
        tasks.forEach { task in
            let index = overlaps[task.id.uuidString]?.firstIndex(of: task) ?? 0
            
            let total = (overlaps.values.filter({ $0.contains(task) }).map({ $0.count }).max() ?? 0)
            
            slots[task.id.uuidString] = (1.0/Double(total), 1.0/Double(total) * Double(index))
        }
        return slots
    }
    
    func findOverlappingTasks(_ range: ClosedRange<Date>, result: [Task] = [], tasks: [Task]) -> [Task] {
        var tasks = tasks.filter({ $0.startTime != nil })
        var result: [Task] = []
        
        if let task = tasks.first(where: { 
            ($0.startTime!...$0.endTime!).overlaps(range)
        }) {
            tasks.removeAll(where: { $0 == task })
            result.append(task)
            
            return result + findOverlappingTasks(range, result: result, tasks: tasks)
        } else {
            return []
        }
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
                            .background(
                                ZStack {
                                    if taskVM.selectedDate == date {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundColor(Color(uiColor: .systemGray5))
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
                                                .sorted(by: { $0.priority.rawValue > $1.priority.rawValue })
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
    }
}

extension TaskView {
    var timelineView: some View {
        VStack(alignment: .leading, spacing: 0) {
//            ScrollView {
//                VStack {
//                    HStack(alignment: .top, spacing: 4) {
//                        switch taskVM.taskListPeriod {
//                        case .day:
//                            VStack(alignment: .leading, spacing: 4) {
//                                ForEach(orderedTasks[taskVM.selectedDate]?
//                                    .filter({ $0.startTime == nil })
//                                    .sorted(by: { $0.priority.rawValue > $1.priority.rawValue })
//                                    .sorted(by: { !$0.completed && $1.completed })
//                                    .sorted(by: {
//                                        if let start1 = $0.startTime, let start2 = $1.startTime {
//                                            return start1 < start2
//                                        } else {
//                                            return false
//                                        }
//                                    }) ?? []) { task in
//                                        timelineTopTaskView(task)
//                                    }
//                                    .frame(alignment: .leading)
//                            }
//                            .frame(maxHeight: 100)
//                        case .week:
//                            ForEach(Date.array(from: taskVM.selectedDate.startOfWeek.startOfDay, to: taskVM.endDate.endOfWeek.startOfDay), id: \.self) { date in
//                                VStack(alignment: .leading, spacing: 4) {
//                                    ForEach(orderedTasks[date]?
//                                        .filter({ $0.startTime == nil })
//                                        .sorted(by: { $0.priority.rawValue > $1.priority.rawValue })
//                                        .sorted(by: { !$0.completed && $1.completed })
//                                        .sorted(by: {
//                                            if let start1 = $0.startTime, let start2 = $1.startTime {
//                                                return start1 < start2
//                                            } else {
//                                                return false
//                                            }
//                                        }) ?? []) { task in
//                                            timelineTopTaskView(task)
//                                        }
//                                        .frame(alignment: .leading)
//                                    
//                                    Spacer()
//                                        .frame(maxWidth: .infinity)
//                                }
//                                .frame(maxHeight: 100)
//                            }
//                        case .month:
//                            ForEach(orderedTasks.elements
//                                .filter({ $0.key == taskVM.selectedDate }), id: \.key) { key, value in
//                                    VStack(alignment: .leading, spacing: 4) {
//                                        ForEach(value
//                                            .filter({ $0.startTime == nil })
//                                            .sorted(by: { $0.priority.rawValue > $1.priority.rawValue })
//                                            .sorted(by: { !$0.completed && $1.completed })
//                                            .sorted(by: {
//                                                if let start1 = $0.startTime, let start2 = $1.startTime {
//                                                    return start1 < start2
//                                                } else {
//                                                    return false
//                                                }
//                                            })) { task in
//                                                timelineTopTaskView(task)
//                                            }
//                                            .frame(alignment: .leading)
//                                    }
//                                    .frame(maxHeight: 100)
//                                }
//                        }
//                    }
//                }
//            }
//                .padding(.horizontal)
//                .padding(.leading, 48)
//                .frame(maxHeight: 100)
            
            ScrollView {
                HStack(alignment: .top) {
                    VStack(spacing: 0) {
                        ForEach(0...24, id: \.self) { hour in
                            let date = Calendar.current.date(from: .init(hour: hour))!
                            VStack {
                                Text(date.formatAs(.h_a))
                                    .font(.system(size: 13, weight: .medium))
                                
                                Spacer()
                            }
                            .frame(height: 75)
                        }
                    }
                    .frame(width: 40)
                    
                    GeometryReader { proxy in
                        ZStack(alignment: .top) {
                            VStack(spacing: 0) {
                                ForEach(0...24, id: \.self) { hour in
                                    VStack {
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(Color(uiColor: .systemGray4))
                                        
                                        Spacer()
                                    }
                                    .frame(height: 75)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(spacing: 0) {
                                    switch taskVM.taskListPeriod {
                                    case .day:
                                        ZStack(alignment: .top) {
                                            let data = orderedTasks[taskVM.selectedDate]?
                                                .sorted(by: { $0.priority.rawValue > $1.priority.rawValue })
                                                .sorted(by: { !$0.completed && $1.completed })
                                                .sorted(by: {
                                                    if let start1 = $0.startTime, let start2 = $1.startTime {
                                                        return start1 < start2
                                                    } else {
                                                        return false
                                                    }
                                                }) ?? []
                                            
                                            ForEach(data) { task in
                                                timelineTaskView(task, allTasks: data, proxy: proxy)
                                            }
                                            .frame(alignment: .leading)
                                        }
                                    case .week:
                                        ZStack(alignment: .top) {
                                            ForEach(Date.array(from: taskVM.selectedDate.startOfWeek.startOfDay, to: taskVM.endDate.endOfWeek.startOfDay), id: \.self) { date in
                                                
                                                let data = orderedTasks[date]?
                                                    .sorted(by: { $0.priority.rawValue > $1.priority.rawValue })
                                                    .sorted(by: { !$0.completed && $1.completed })
                                                    .sorted(by: {
                                                        if let start1 = $0.startTime, let start2 = $1.startTime {
                                                            if let end1 = $0.endTime, let end2 = $1.endTime {
                                                                let duration1 = end1.distance(to: start1)
                                                                let duration2 = end2.distance(to: start2)
                                                                
                                                                return duration1 < duration2
                                                            }
                                                            
                                                            return start1 < start2
                                                        } else {
                                                            return false
                                                        }
                                                    }) ?? []
                                                
                                                ForEach(data) { task in
                                                    timelineTaskView(task, allTasks: data, proxy: proxy)
                                                }
                                                
                                                Spacer()
                                            }
                                        }
                                    case .month:
                                        ForEach(orderedTasks.elements
                                            .filter({ $0.key == taskVM.selectedDate }), id: \.key) { key, value in
                                                ZStack(alignment: .top) {
                                                    let data = value
                                                        .sorted(by: { $0.priority.rawValue > $1.priority.rawValue })
                                                        .sorted(by: { !$0.completed && $1.completed })
                                                        .sorted(by: {
                                                            if let start1 = $0.startTime, let start2 = $1.startTime {
                                                                return start1 < start2
                                                            } else {
                                                                return false
                                                            }
                                                        })
                                                    
                                                    ForEach(data) { task in
                                                            timelineTaskView(task, allTasks: data, proxy: proxy)
                                                        }
                                                        .frame(alignment: .leading)
                                                }
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder
    func timelineTaskView(_ task: Task, allTasks: [Task], proxy: GeometryProxy) -> some View {
        if let startTime = task.startTime {
            let startHour = Double(Calendar.current.component(.hour, from: startTime))
            let startMinute = Double(Calendar.current.component(.minute, from: startTime))
            
            let endHour = task.endTime != nil ? Double(Calendar.current.component(.hour, from: task.endTime!)) : 0
            let endMinute = task.endTime != nil ? Double(Calendar.current.component(.minute, from: task.endTime!)) : 0
            
            let startOffset: CGFloat = CGFloat(((startHour - 1) + startMinute / 60.0 ) / 24.0 * 24.0 * Double(75.0))
            let endOffset: CGFloat = CGFloat(((endHour - 1) + endMinute / 60.0 ) / 24.0 * 24.0 * Double(75.0))
            
            var width: CGFloat {
                return (taskSlots[task.id.uuidString]?.width ?? 1) * proxy.size.width
            }
            
            var offset: CGFloat {
                let taskOffset = taskSlots[task.id.uuidString]?.offset ?? 0
                return -(proxy.size.width - width) / 2 + (taskOffset * proxy.size.width)
            }
            
            HStack(alignment: .top, spacing: 8) {
                Rectangle()
                    .frame(width: 2)
                    .foregroundColor(task.priority.color)
                
                Text(task.title)
                    .strikethrough(task.completed, color: .gray)
                    .foregroundStyle(task.completed ? .gray : .black)
                    .font(.system(size: 17, weight: .medium))
                    .padding(.vertical, 4)
            }
            .frame(width: width, height: max(48, endOffset - startOffset), alignment: .leading)
            .background(task.priority.color.opacity(0.2))
            .cornerRadius(4)
            .offset(x: offset, y: startOffset)
        }
    }
    
    
    @ViewBuilder
    func timelineTopTaskView(_ task: Task) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Rectangle()
                .frame(width: 2)
                .foregroundColor(task.priority.color)
            
            Text(task.title)
                .strikethrough(task.completed, color: .gray)
                .foregroundStyle(task.completed ? .gray : .black)
                .font(.system(size: 17, weight: .medium))
            //                    .lineLimit(1)
                .padding(.vertical, 4)
        }
        .frame(height: 48, alignment: .leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(task.priority.color.opacity(0.2))
        .cornerRadius(4)
    }
}

#Preview {
    TaskView()
}
