//
//  TrueFitApp.swift
//  TrueFit
//
//  Created by mohamed sharaf on 27/06/2026.
//

import SwiftUI

@main
struct TrueFitApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            OnboardingContentView(index:1, title: "ASDASDSADSA", desc: "asdasdasd")
        }
    }
}
