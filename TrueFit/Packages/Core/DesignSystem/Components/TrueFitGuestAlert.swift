import SwiftUI

public struct TrueFitGuestAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    @EnvironmentObject var container: DIContainer
    
    public func body(content: Content) -> some View {
        content.trueFitAlert(
            isPresented: $isPresented,
            title: "Sign In Required",
            message: "You must be signed in to perform this action. Sign in or create an account to continue.",
            primaryActionTitle: "Sign In",
            isPrimaryDestructive: false,
            onPrimaryAction: {
                // To show the sign-in screen, we cleanly exit guest mode.
                // This preserves cart/keychain data but routes the app back to AuthFlowView.
                Task {
                    container.authManager.setGuestMode(false)
                    container.appRouter.popAllToRoot()
                }
            },
            secondaryActionTitle: "Not Now"
        )
    }
}

public extension View {
    /// A common view modifier to show a generic alert when a guest tries to access protected features.
    /// It automatically handles routing the user to the Sign In screen if they tap "Sign In".
    func trueFitGuestAlert(isPresented: Binding<Bool>) -> some View {
        self.modifier(TrueFitGuestAlertModifier(isPresented: isPresented))
    }
}
