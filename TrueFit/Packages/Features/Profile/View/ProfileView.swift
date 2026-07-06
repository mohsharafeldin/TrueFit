import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var authRouter: AuthRouter
    
    @State private var showingLogoutAlert = false
    @State private var showGuestAlert = false
    
    init(viewModelFactory: @escaping () -> ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Section 1: Header
                ProfileHeaderView(user: viewModel.currentUser)
                
                // Section 2: Account Management
                ProfileAccountSection(isGuest: viewModel.isGuest, showGuestAlert: $showGuestAlert)
                
                // Section 3: Preferences
                ProfilePreferencesSection()
                
                // Section 4: Support & Info
                ProfileSupportSection()
                
                // Section 5: Bottom Action
                ProfileBottomActionSection(viewModel: viewModel, showingLogoutAlert: $showingLogoutAlert)
            }
            .padding(.vertical, Spacing.xl)
        }
        .background(Color.trueFitBackground.ignoresSafeArea())
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadUser()
        }
        .trueFitGuestAlert(isPresented: $showGuestAlert)
        .alert("Logout", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Logout", role: .destructive) {
                Task {
                    await viewModel.logout()
                    authRouter.popToRoot() // Resets the Auth flow back to the Welcome screen
                    appRouter.popAllToRoot() // Resets the Tab Bar back to Home for the next login
                }
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
        .trueFitToast(
            message: Binding(
                get: { viewModel.errorMessage },
                set: { if $0 == nil { viewModel.errorMessage = nil } }
            ),
            style: .error
        )
    }
    
}
