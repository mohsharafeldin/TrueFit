//
//  ContainerProtocol.swift
//  TrueFit
//
//  Created by Mona Zarea on 27/06/2026.
//


import Foundation
import CoreData


@MainActor
final class DIContainer: ObservableObject {
    
    let persistenceController: PersistenceController
    let authManager = AuthManager()
    
    init() {
        self.persistenceController = PersistenceController.shared
        
    }
    
    
    func makeRootViewModel() -> RootViewModel {
        return RootViewModel(authManager: self.authManager)
    }
    
}
