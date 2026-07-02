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
                    
                    HStack(spacing: Spacing.sm) {
                        Button(action: { viewModel.decreaseQuantity() }) {
                            Image(systemName: "minus")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.textPrimary)
                                .frame(width: 24, height: 24)
                        }
                        
                        Text("\(viewModel.quantity)")
                            .trueFitTextStyle(.subheadline)
                            .fontWeight(.bold)
                            .frame(minWidth: 20)
                        
                        Button(action: { viewModel.increaseQuantity() }) {
                            Image(systemName: "plus")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.textPrimary)
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding(.horizontal, Spacing.sm)
                    .padding(.vertical, Spacing.xs)
                    .background(Color.surface)
                    .clipShape(RoundedRectangle.trueFit(Radius.pill))
                    .trueFitShadow(.xs)
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
                        dynamicOptionSection(option: option)
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
    private func dynamicOptionSection(option: ProductOption) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(option.name)
                .trueFitTextStyle(.title3)
                .foregroundColor(.textPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.sm) {
                    ForEach(option.values, id: \.self) { value in
                        if option.name.lowercased().contains("color") || option.name.lowercased().contains("colour") {
                            Circle()
                                .fill(colorFromString(value))
                                .frame(width: 35, height: 35)
                                .overlay(
                                    Circle().stroke(Color.borderColor, lineWidth: 1)
                                )
                        } else {
                            Text(value)
                                .trueFitTextStyle(.callout)
                                .padding(.horizontal, Spacing.lg)
                                .padding(.vertical, Spacing.sm)
                                .background(Color.surface)
                                .clipShape(RoundedRectangle.trueFit(Radius.md))
                                .overlay(
                                    RoundedRectangle.trueFit(Radius.md)
                                        .stroke(Color.borderColor, lineWidth: 1)
                                )
                        }
                    }
                }
            }
        }
    }
    
    private func colorFromString(_ colorName: String) -> Color {
        switch colorName.lowercased() {
        case "red": return .red
        case "black": return .black
        case "blue": return .brandPrimary
        case "green": return .brandSecondary
        case "white": return .white
        case "gray", "grey": return .gray
        case "brown": return .brown
        default: return .disabledColor
        }
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
        case .outOfStock:
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
        }
    }
}
