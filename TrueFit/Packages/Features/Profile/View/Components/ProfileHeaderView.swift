import SwiftUI

struct ProfileHeaderView: View {
    let user: User?
    
    var body: some View {
        VStack(spacing: Spacing.md) {
            Image("user")
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
            
            if let user = user {
                VStack(spacing: Spacing.xxs) {
                    Text("\(user.firstName) \(user.lastName)")
                        .trueFitTextStyle(.title2)
                        .foregroundColor(.textPrimary)
                    
                    Text(user.email)
                        .trueFitTextStyle(.body)
                        .foregroundColor(.textSecondary)
                }
            } else {
                Text("Guest User")
                    .trueFitTextStyle(.title2)
                    .foregroundColor(.textPrimary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Spacing.lg)
    }
}
