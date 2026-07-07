import SwiftUI

struct CartCheckoutBar: View {
    @ObservedObject var viewModel: CartViewModel
    let cart: Cart
    let onCheckout: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.borderColor)
                .shadow(color: Color.shadowColor.opacity(0.05), radius: 4, x: 0, y: -2)
            
            Button(action: {
                onCheckout()
            }) {
                HStack {
                    Text("Checkout — \(viewModel.totalText)")
                }
                .trueFitTextStyle(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 54)
                .background(viewModel.isUpdating || cart.isEmpty ? Color.disabledColor : Color.brandPrimary)
                .clipShape(RoundedRectangle.trueFit(Radius.xl))
            }
            .disabled(viewModel.isUpdating || cart.isEmpty)
            .accessibilityLabel("Checkout, total \(viewModel.totalText)")
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.md)
            .background(Color.trueFitBackground)
        }
    }
}
