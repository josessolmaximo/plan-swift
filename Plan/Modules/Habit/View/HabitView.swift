//
//  HabitView.swift
//  Plan
//
//  Created by Joses Solmaximo on 25/01/24.
//

import SwiftUI

struct HabitView: View {
    @State var habits: [Task] = []
    
    @State var isFull: Double = 0
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                ZStack {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "chart.bar")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        })
                        .foregroundColor(.black)
                    }
                    
                    HStack {
                        Text("Habits")
                            .font(.system(size: 17, weight: .semibold))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(habits) { habit in
                            HabitRowView(habit: habit) { habit in
                                let isCompletedToday = habit.completedOn?.contains(Date().startOfDay) ?? false
                                
//                                if let index = habits.firstIndex(where: { $0.id == habit.id }) {
//                                    if isCompletedToday {
//                                        habits[index].completedOn.removeAll(where: { $0 == Date().startOfDay })
//                                    } else {
//                                        habits[index].completedOn.append(Date().startOfDay)
//                                    }
//                                }
                            }
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
