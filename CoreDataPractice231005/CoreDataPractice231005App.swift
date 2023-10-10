//
//  CoreDataPractice231005App.swift
//  CoreDataPractice231005
//
//  Created by Wonil Lee on 10/5/23.
//

import SwiftUI

@main
struct CoreDataPractice231005App: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainView_FetchFunction()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            MainView_FetchedResults()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
