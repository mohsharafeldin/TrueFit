import SwiftUI

struct ProductDetailsBottomBar: View {
    @ObservedObject var viewModel: ProductDetailsViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: Spacing.md) {
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Total Price")
                    .trueFitTextStyle(.caption2)
                    .foregroundColor(.textSecondary)
                HStack(alignment: .firstTextBaseline, spacing: Spacing.sm) {
                    Text(viewModel.displayedTotalPrice)
                        .trueFitTextStyle(.headline)
                        .foregroundColor(.textPrimary)
                        .bold()
                    
                    if let oldTotal = viewModel.displayedTotalCompareAtPrice {
                        Text(oldTotal)
                            .trueFitTextStyle(.headline)
                            .trueFitTextStyle(.subheadline)
                            .foregroundColor(.textTertiary)
                            .strikethrough()
                    }
                    
                }
            }
            
            Spacer()
            
            
            Button(action: {
                Task {
                    await viewModel.addToCart()
                }
            }) {
                HStack(spacing: Spacing.sm) {
                    if viewModel.isAddingToCart {
                        ProgressView()
                            .tint(.surface)
                        
                        Text("Adding...")
                            .trueFitTextStyle(.headline)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    } else {
                        Image(systemName: "bag.fill")
                            .font(.system(size: 16))
                        
                        Text(viewModel.isAddToCartDisabled ? (viewModel.quantity > (viewModel.maxQuantity ?? Int.max) ? "Max Stock Reached" : "Out of Stock") : "Add to Cart")
                            .trueFitTextStyle(.headline)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                }
                .foregroundColor(.surface)
                .frame(height: 50)
                .padding(.horizontal, Spacing.lg)
                .background(viewModel.isAddToCartDisabled || viewModel.isAddingToCart ? Color.disabledColor : Color.brandPrimary)
                .clipShape(Capsule())
            }
            .disabled(viewModel.isAddToCartDisabled || viewModel.isAddingToCart)
        }
        .padding(.horizontal, Spacing.xl)
        .padding(.vertical, Spacing.sm)
        .background(Color.surface)
        .trueFitShadow(.sm)
    }
}
