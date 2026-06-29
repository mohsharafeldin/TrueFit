//
//  TrueFitApp.swift
//  TrueFit
//
//  Created by Mona Zarea on 27/06/2026.
//

import SwiftUI
import CoreData
@main
struct TrueFitApp: App {
    @StateObject private var diContainer = DIContainer()
    
   

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: diContainer.makeRootViewModel())
                .environmentObject(diContainer.authRouter)
                .environmentObject(diContainer.appRouter)
                .environmentObject(diContainer)
                .environment(\.managedObjectContext, diContainer.persistenceController.container.viewContext)
        }
    }
}

