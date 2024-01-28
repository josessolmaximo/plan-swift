//
//  ContentView.swift
//  Plan
//
//  Created by Joses Solmaximo on 03/11/23.
//

import SwiftUI

struct ContentView: View {
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    
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
            }
            .accentColor(.black)
        }
    }
}

#Preview {
    ContentView()
}
