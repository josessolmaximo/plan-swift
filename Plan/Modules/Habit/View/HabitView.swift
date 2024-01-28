//
//  HabitView.swift
//  Plan
//
//  Created by Joses Solmaximo on 25/01/24.
//

import SwiftUI

struct HabitView: View {
    @State var habits: [Task] = Task.randomTasks(10)
    
    @State var isFull: Double = 0
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                ZStack {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                        })
                        .foregroundColor(.black)
                    }
                    
                    HStack {
                        Text("Habits")
                            .font(.system(size: 17, weight: .semibold))
                    }
                }
                .padding(.horizontal, 16)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(habits) { habit in
                            VStack(spacing: 16) {
                                HStack(spacing: 16) {
                                    if let image = habit.image {
                                        Image(systemName: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(habit.priority.color)
                                    } else {
                                        RoundedRectangle(cornerRadius: 4)
                                            .foregroundColor(Color(uiColor: .systemGray5))
                                            .frame(width: 20, height: 20)
                                    }
                                    
                                    Text(habit.title)
                                        .font(.system(size: 17, weight: .medium))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    let isCompletedToday = habit.completedOn.contains(Date().startOfDay)
                                    
                                    Button {
                                        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
                                            if isCompletedToday {
                                                habits[index].completedOn.removeAll(where: { $0 == Date().startOfDay })
                                            } else {
                                                habits[index].completedOn.append(Date().startOfDay)
                                            }
                                        }
                                    } label: {
                                        Image(systemName: isCompletedToday ? "checkmark.square.fill" : "square")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(isCompletedToday ? .gray : habit.priority.color)
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
                                let gridSize: CGFloat = 12
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHGrid(rows: Array(repeating: .init(.fixed(gridSize), spacing: spacing), count: 7), spacing: spacing, content: {
                                        
                                        ForEach(dates, id: \.self) { date in
                                            let isCompleted = habit.completedOn.contains(date)
                                            
                                            RoundedRectangle(cornerRadius: gridSize/4)
                                                .foregroundColor(habit.priority.color.opacity(isCompleted ? 1 : 0.1))
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
                }
            }
        }
    }
}

#Preview {
    HabitView()
}
