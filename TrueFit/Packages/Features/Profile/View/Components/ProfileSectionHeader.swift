import SwiftUI

struct ProfileSectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title.uppercased())
            .trueFitTextStyle(.caption)
            .foregroundColor(.textSecondary)
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, Spacing.xs)
    }
}
