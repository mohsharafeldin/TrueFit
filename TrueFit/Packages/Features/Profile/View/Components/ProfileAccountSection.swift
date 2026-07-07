import SwiftUI

struct ProfileAccountSection: View {
    let isGuest: Bool
    @Binding var showGuestAlert: Bool
    @EnvironmentObject var appRouter: AppRouter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ProfileSectionHeader(title: "Account")
            
            VStack(spacing: 0) {
                ProfileRow(icon: "bag", title: "My Orders") {
                    if isGuest {
                        showGuestAlert = true
                    } else {
                        appRouter.navigate(to: .orders)
                    }
                }
                Divider().padding(.leading, 48)
                
                ProfileRow(icon: "map", title: "My Addresses") {
                    if isGuest {
                        showGuestAlert = true
                    } else {
                        // Navigate to Addresses
                    }
                }
            }
            .background(Color.surface)
            .clipShape(RoundedRectangle.trueFit(Radius.md))
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .padding(.horizontal, Spacing.md)
        }
    }
}
