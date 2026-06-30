//
//  PreferencesManager.swift
//  TrueFit
//
//  Created by Mona Zarea on 29/06/2026.
//

import Foundation


import Foundation

protocol PreferencesManagerProtocol {
    var hasSeenOnboarding: Bool { get set }
    
}

final class PreferencesManager: PreferencesManagerProtocol {
    
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    private enum Keys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
    }
    
    var hasSeenOnboarding: Bool {
        get {
            return defaults.bool(forKey: Keys.hasSeenOnboarding)
        }
        set {
            defaults.set(newValue, forKey: Keys.hasSeenOnboarding)
        }
    }
}
