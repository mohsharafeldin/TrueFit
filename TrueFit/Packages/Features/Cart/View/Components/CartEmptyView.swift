import SwiftUI

struct CartEmptyView: View {
    let onStartShopping: () -> Void
    var isGuest: Bool = false
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            Image(systemName: isGuest ? "person.crop.circle.badge.exclamationmark" : "cart")
                .font(.system(size: 64, weight: .light))
                .foregroundColor(.textTertiary)
                .padding(.bottom, Spacing.md)
            
            VStack(spacing: Spacing.xs) {
                Text(isGuest ? "Login Required" : "Your cart is empty")
                    .trueFitTextStyle(.title1)
                    .foregroundColor(.textPrimary)
                
                Text(isGuest ? "Please log in to view and checkout your cart items." : "Looks like you haven't added anything yet")
                    .trueFitTextStyle(.body)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if !isGuest {
                Button(action: onStartShopping) {
                    Text("Start Shopping")
                        .trueFitTextStyle(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 54)
                        .background(Color.brandPrimary)
                        .clipShape(RoundedRectangle.trueFit(Radius.xl))
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.top, Spacing.lg)
            }
        }
        .padding(Spacing.md)
    }
}
