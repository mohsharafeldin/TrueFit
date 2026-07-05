import SwiftUI

struct ProductDetailsCard: View {
    let product: Product
    @ObservedObject var viewModel: ProductDetailsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xl) {
            
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack(alignment: .top) {
                    Text(product.title)
                        .trueFitTextStyle(.title3)
                        .foregroundColor(.textPrimary)
                    
                    Spacer(minLength: Spacing.md)
                    
                    TrueFitStepper(
                        quantity: viewModel.quantity,
                        maxQuantity: viewModel.maxQuantity,
                        onIncrement: { viewModel.increaseQuantity() },
                        onDecrement: { viewModel.decreaseQuantity() }
                    )
                }
                
                HStack(alignment: .center) {
                    HStack(spacing: Spacing.xxs) {
                        Image(systemName: "star.fill").foregroundColor(.statusRating)
                        Text("4.8").trueFitTextStyle(.subheadline).bold()
                        Text("(320 Review)").trueFitTextStyle(.subheadline).foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    stockStatusView(status: viewModel.stockStatus)
                }
            }
            
            if !product.options.isEmpty && product.options.first?.name.lowercased() != "title" {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    ForEach(product.options, id: \.id) { option in
                        ProductOptionSectionView(option: option, viewModel: viewModel)
                    }
                }
            }
            
            if !product.description.isEmpty {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("Description")
                        .trueFitTextStyle(.title3)
                        .foregroundColor(.textPrimary)
                    
                    Text(product.description)
                        .trueFitTextStyle(.body)
                        .foregroundColor(.textSecondary)
                        .lineSpacing(6)
                }
            }
        }
        .padding(Spacing.xl)
    }
    

    @ViewBuilder
    private func stockStatusView(status: StockStatus) -> some View {
        HStack(spacing: Spacing.xxs) {
            Circle()
                .fill(stockColor(for: status))
                .frame(width: 8, height: 8)
            
            Text(stockText(for: status))
                .trueFitTextStyle(.caption)
                .foregroundColor(stockColor(for: status))
                .bold()
        }
    }
    
    private func stockColor(for status: StockStatus) -> Color {
        switch status {
        case .inStock, .available:
            return .brandSecondary
        case .outOfStock, .unavailable:
            return .red
        }
    }
    
    private func stockText(for status: StockStatus) -> String {
        switch status {
        case .inStock(let qty):
            return "In Stock (\(qty))"
        case .available:
            return "Available"
        case .outOfStock:
            return "Out of Stock"
        case .unavailable:
            return "Unavailable"
        }
    }
}
