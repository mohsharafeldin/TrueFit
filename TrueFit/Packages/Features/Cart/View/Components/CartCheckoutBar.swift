import SwiftUI

struct CartCheckoutBar: View {
    @ObservedObject var viewModel: CartViewModel
    let cart: Cart
    let openURL: OpenURLAction
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.borderColor)
                .shadow(color: Color.shadowColor.opacity(0.05), radius: 4, x: 0, y: -2)
            
            Button(action: {
                if let url = viewModel.checkoutURL {
                    openURL(url)
                }
            }) {
                HStack {
                    if viewModel.checkoutURL == nil {
                        Text("Unavailable")
                    } else {
                        Text("Checkout — \(viewModel.totalText)")
                    }
                }
                .trueFitTextStyle(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 54)
                .background(viewModel.isUpdating || cart.isEmpty || viewModel.checkoutURL == nil ? Color.disabledColor : Color.brandPrimary)
                .clipShape(RoundedRectangle.trueFit(Radius.xl))
            }
            .disabled(viewModel.isUpdating || cart.isEmpty || viewModel.checkoutURL == nil)
            .accessibilityLabel("Checkout, total \(viewModel.totalText)")
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.md)
            .background(Color.trueFitBackground)
        }
    }
}
