import SwiftUI

struct ProfileBottomActionSection: View {
    @ObservedObject var viewModel: ProfileViewModel
    @EnvironmentObject var appRouter: AppRouter
    @Binding var showingLogoutAlert: Bool
    
    var body: some View {
        Button(action: {
            if viewModel.isGuest {
                viewModel.navigateToLogin() // Safely exit guest mode without wiping keychain
                appRouter.popAllToRoot() // Resets the Tab Bar back to Home for the next login
            } else {
                showingLogoutAlert = true
            }
        }) {
            HStack {
                Spacer()
                if viewModel.isLoggingOut {
                    ProgressView().tint(.white)
                } else {
                    Text(viewModel.isGuest ? "Login" : "Logout")
                        .trueFitTextStyle(.headline)
                }
                Spacer()
            }
            .padding(.vertical, Spacing.md)
            .background(viewModel.isGuest ? Color.brandPrimary : Color.semanticDanger)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle.trueFit(Radius.md))
            .padding(.horizontal, Spacing.md)
        }
        .disabled(viewModel.isLoggingOut)
    }
}
