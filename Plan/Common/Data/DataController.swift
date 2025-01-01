//
//  DataController.swift
//  Plan
//
//  Created by Joses Solmaximo on 10/02/24.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Plan")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("debug error")
                fatalError(error.localizedDescription)
            }
        }
    }
}
