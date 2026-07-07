import SwiftUI

struct ProfileRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                Image(systemName: icon)
                    .foregroundColor(.textSecondary)
                    .font(.system(size: 20))
                    .frame(width: 24)
                
                Text(title)
                    .trueFitTextStyle(.body)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.borderColor)
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding(.vertical, Spacing.md)
            .padding(.horizontal, Spacing.md)
        }
    }
}
