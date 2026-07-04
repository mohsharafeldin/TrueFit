import SwiftUI

struct CartSummarySection: View {
    @ObservedObject var viewModel: CartViewModel
    let cart: Cart
    
    var body: some View {
        VStack(spacing: Spacing.md) {
            summaryRow(label: "Subtotal", value: viewModel.subtotalText)
            
            if let tax = viewModel.totalTaxText {
                summaryRow(label: "Tax", value: tax)
            }
            
            if viewModel.hasActiveDiscount {
                HStack {
                    Text("Promo applied")
                        .trueFitTextStyle(.body)
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.semanticSuccess)
                }
            }
            
            Divider()
                .background(Color.borderColor)
            
            HStack {
                Text("Total")
                    .trueFitTextStyle(.title3)
                    .foregroundColor(.textPrimary)
                Spacer()
                Text(viewModel.totalText)
                    .trueFitTextStyle(.title3)
                    .foregroundColor(.textPrimary)
            }
        }
        .padding(Spacing.lg)
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.lg))
        .shadow(color: Color.shadowColor.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private func summaryRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .trueFitTextStyle(.body)
                .foregroundColor(.textSecondary)
            Spacer()
            Text(value)
                .trueFitTextStyle(.body)
                .foregroundColor(.textPrimary)
        }
    }
}
