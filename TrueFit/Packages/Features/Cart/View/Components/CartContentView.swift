import SwiftUI

struct CartContentView: View {
    let cart: Cart
    @ObservedObject var viewModel: CartViewModel
    @Binding var isDiscountExpanded: Bool
    let onCheckout: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: Spacing.xl) {
                    
                    // Lines
                    ZStack {
                        VStack(spacing: Spacing.xl) {
                            ForEach(cart.lines, id: \.id) { line in
                                CartLineRow(line: line, viewModel: viewModel)
                            }
                        }
                        .padding(.top, Spacing.md)
                        
                        if viewModel.isUpdating {
                            Color.surface.opacity(0.6)
                                .ignoresSafeArea()
                            ProgressView()
                                .tint(.brandPrimary)
                        }
                    }
                    .disabled(viewModel.isUpdating)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.isUpdating)
                    
                    // Discount Section
                    CartDiscountSection(
                        cart: cart,
                        viewModel: viewModel,
                        isDiscountExpanded: $isDiscountExpanded
                    )
                    .padding(.horizontal, Spacing.md)
                    .padding(.top, Spacing.xl)
                    
                    // Summary Section
                    CartSummarySection(viewModel: viewModel, cart: cart)
                        .padding(.horizontal, Spacing.md)
                        .padding(.top, Spacing.lg)
                }
            }
            
            // Checkout Bar
            CartCheckoutBar(viewModel: viewModel, cart: cart, onCheckout: onCheckout)
        }
    }
}
