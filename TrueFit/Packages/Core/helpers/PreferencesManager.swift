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
    var hasRunBefore: Bool { get set }
    var cartId: String? { get set }
    var cartItemCount: Int { get set }
    
    func saveUser(_ user: User)
       func getUser() -> User?
       func clearUser()
}

final class PreferencesManager: PreferencesManagerProtocol {
    
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    private enum Keys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
        static let hasRunBefore = "hasRunBefore"
        static let cartId = "cartId"
        static let currentUser = "currentUser"
    }
    
    var hasSeenOnboarding: Bool {
        get { return defaults.bool(forKey: Keys.hasSeenOnboarding) }
        set { defaults.set(newValue, forKey: Keys.hasSeenOnboarding) }
    }
    
    var hasRunBefore: Bool {
        get { return defaults.bool(forKey: Keys.hasRunBefore) }
        set { defaults.set(newValue, forKey: Keys.hasRunBefore) }
    }
    
    var cartId: String? {
        get { defaults.string(forKey: Keys.cartId) }
        set { defaults.set(newValue, forKey: Keys.cartId) }
    }
    
    var cartItemCount: Int {
        get { defaults.integer(forKey: "cartItemCount") }
        set { defaults.set(newValue, forKey: "cartItemCount") }
    }
    
    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            defaults.set(encoded, forKey: Keys.currentUser)
        }
    }
    
    func getUser() -> User? {
        guard let data = defaults.data(forKey: Keys.currentUser),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    func clearUser() {
        defaults.removeObject(forKey: Keys.currentUser)
    }
}
