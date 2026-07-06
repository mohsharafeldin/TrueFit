import SwiftUI

struct ProfilePreferencesSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ProfileSectionHeader(title: "Preferences")
            
            VStack(spacing: 0) {
                ProfileRow(icon: "dollarsign.circle", title: "Currency") {
                    // Navigate to Currency Selection Screen
                }
            }
            .background(Color.surface)
            .clipShape(RoundedRectangle.trueFit(Radius.md))
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .padding(.horizontal, Spacing.md)
        }
    }
}
