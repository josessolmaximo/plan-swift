//
//  ContentView.swift
//  Plan
//
//  Created by Joses Solmaximo on 03/11/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var context
    
    @StateObject var taskVM = TaskViewModel()
    @State var isTaskSheetShown = false
    
    var body: some View {
        NavigationView {
            TabView {
                TaskView()
                    .accentColor(.none)
                    .tabItem {
                        Label("Task", systemImage: "list.bullet")
                    }
                
                HabitView()
                    .accentColor(.none)
                    .tabItem {
                        Label("Habit", systemImage: "square.grid.3x3.topleft.filled")
                    }
                
                Color.clear
                    .tabItem {  }
            }
            .sheet(isPresented: $isTaskSheetShown, content: {
                TaskSheetView(task: Task(context: context))
            })
            .accentColor(.black)
            .overlay(
                ZStack {
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                isTaskSheetShown.toggle()
                            }, label: {
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .padding(16)
                                    .background(.black)
                                    .clipped()
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                            })
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                            .frame(height: 56)
                    }
                }
            )
        }
        .environmentObject(taskVM)
        .onAppear {
            let mf = MeasurementFormatter()
        }
    }
}

#Preview {
    ContentView()
}
