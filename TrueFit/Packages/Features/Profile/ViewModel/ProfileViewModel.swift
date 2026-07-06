import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isGuest: Bool = false
    @Published var isLoggingOut: Bool = false
    @Published var errorMessage: String?
    
    private let preferencesManager: PreferencesManagerProtocol
    private let authManager: AuthManagerProtocol
    private let logoutUseCase: LogoutUseCaseProtocol
    
    init(
        preferencesManager: PreferencesManagerProtocol,
        authManager: AuthManagerProtocol,
        logoutUseCase: LogoutUseCaseProtocol
    ) {
        self.preferencesManager = preferencesManager
        self.authManager = authManager
        self.logoutUseCase = logoutUseCase
    }
    
    func loadUser() {
        self.isGuest = authManager.isGuest || !authManager.isAuthenticated
        self.currentUser = preferencesManager.getUser()
    }
    
    func logout() async {
        isLoggingOut = true
        errorMessage = nil
        defer { isLoggingOut = false }
        
        do {
            try await logoutUseCase.execute()
            preferencesManager.clearUser()
            // AuthManager handles its own cleanup if needed, but we can explicitly call logout
            authManager.logout()
            
            // Reload state
            loadUser()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func navigateToLogin() {
        authManager.setGuestMode(false)
    }
}
