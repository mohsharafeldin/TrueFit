import SwiftUI

struct CartFailureView: View {
    let error: AppError
    let onRetry: (() -> Void)?
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            Image(systemName: error == .noInternet ? "wifi.slash" : "cart.badge.minus")
                .font(.system(size: 64, weight: .light))
                .foregroundColor(.semanticDanger)
                .padding(.bottom, Spacing.md)
            
            Text(error.userMessage)
                .trueFitTextStyle(.title3)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xl)
            
            if let onRetry = onRetry {
                Button(action: onRetry) {
                    Text("Retry")
                        .trueFitTextStyle(.headline)
                        .foregroundColor(.brandPrimary)
                        .frame(maxWidth: .infinity, minHeight: 54)
                        .background(Color.surface)
                        .clipShape(RoundedRectangle.trueFit(Radius.xl))
                        .overlay(
                            RoundedRectangle(cornerRadius: Radius.xl)
                                .stroke(Color.brandPrimary, lineWidth: 1)
                        )
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.top, Spacing.md)
            }
        }
    }
}
