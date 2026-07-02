import SwiftUI

struct ProductDetailsBottomBar: View {
    @ObservedObject var viewModel: ProductDetailsViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: Spacing.md) {
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Total Price")
                    .trueFitTextStyle(.caption2)
                    .foregroundColor(.textSecondary)
                Text(viewModel.displayedTotalPrice)
                    .trueFitTextStyle(.headline)
                    .foregroundColor(.textPrimary)
                    .bold()
            }
            
            Spacer()
            
            Button(action: { viewModel.addToCart() }) {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: "bag.fill")
                        .font(.system(size: 16))
                    
                    Text("Add to Cart")
                        .trueFitTextStyle(.headline)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }
                .foregroundColor(.surface)
                .frame(height: 50)
                .padding(.horizontal, Spacing.lg)
                .background(Color.brandPrimary)
                .clipShape(Capsule())
            }
        }
        .padding(.horizontal, Spacing.xl)
        .padding(.vertical, Spacing.sm)
        .background(Color.surface)
        .trueFitShadow(.sm)
    }
}
