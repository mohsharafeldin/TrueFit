//
//  TrueFitApp.swift
//  TrueFit
//
//  Created by Mona Zarea on 27/06/2026.
//

import SwiftUI
import FirebaseCore
import CoreData

@main
struct TrueFitApp: App {
    @StateObject private var diContainer = DIContainer()
    
    init() {
            FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(viewModel: diContainer.makeRootViewModel())
                .environmentObject(diContainer.authRouter)
                .environmentObject(diContainer.appRouter)
                .environmentObject(diContainer)
                .environmentObject(diContainer.cartState)
                .environment(\.managedObjectContext, diContainer.persistenceController.container.viewContext)
        }
    }
}

