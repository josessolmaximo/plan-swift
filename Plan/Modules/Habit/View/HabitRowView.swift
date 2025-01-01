//
//  HabitRowView.swift
//  Plan
//
//  Created by Joses Solmaximo on 29/01/24.
//

import SwiftUI

struct HabitRowView: View {
    let habit: Task
    let text: Binding<String>?
    let onTapped: (Task) -> Void
    
    init(habit: Task, text: Binding<String>? = nil, onTapped: @escaping (Task) -> Void) {
        self.habit = habit
        self.text = text
        self.onTapped = onTapped
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                Image(systemName: habit.image ?? "")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(habit.priorityEnum.color)
                
                if let text = text {
                   TextField("Title", text: text)
                        .font(.system(size: 17, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text(habit.title ?? "")
                        .font(.system(size: 17, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                let isCompletedToday = habit.completedOn?.contains(Date().startOfDay) ?? false
                
                Button {
                    onTapped(habit)
                } label: {
                    Image(systemName: isCompletedToday ? "checkmark.square.fill" : "square")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(isCompletedToday ? .gray : habit.priorityEnum.color)
                }
            }
            
            var dates: [Date] {
                var dates: [Date] = []
                var startDate = Date().startOfYear.startOfDay
                
                while startDate < Date().endOfYear.startOfDay {
                    dates.append(startDate)
                    startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
                }
                
                return dates
            }
            
            let spacing: CGFloat = 2.5
            let gridSize: CGFloat = 10
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: Array(repeating: .init(.fixed(gridSize), spacing: spacing), count: 7), spacing: spacing, content: {
                    
                    ForEach(dates, id: \.self) { date in
                        let isCompleted = habit.completedOn?.contains(date) ?? false
                        
                        RoundedRectangle(cornerRadius: gridSize/4)
                            .foregroundColor(habit.priorityEnum.color.opacity(isCompleted ? 1 : 0.1))
                            .frame(width: gridSize, height: gridSize)
                    }
                })
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .contextMenu(ContextMenu(menuItems: {
            Text("Test")
        }))
        .cornerRadius(16)
    }
}

//#Preview {
//    ScrollView {
//        VStack {
//            HabitRowView(habit: Task.randomTasks(1)[0], onTapped: { habit in
//                
//            })
//            
//            Spacer()
//        }
//    }
//}
