//
//  PlanApp.swift
//  Plan
//
//  Created by Joses Solmaximo on 03/11/23.
//

import SwiftUI

@main
struct PlanApp: App {
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
