import SwiftUI

struct CartDiscountSection: View {
    let cart: Cart
    @ObservedObject var viewModel: CartViewModel
    @Binding var isDiscountExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Button(action: {
                withAnimation(.spring()) {
                    isDiscountExpanded.toggle()
                }
            }) {
                HStack {
                    Text("Have a promo code?")
                        .trueFitTextStyle(.headline)
                        .foregroundColor(.textPrimary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textSecondary)
                        .rotationEffect(.degrees(isDiscountExpanded ? 90 : 0))
                }
                .padding(.vertical, Spacing.xs)
            }
            
            if viewModel.hasActiveDiscount {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.xs) {
                        ForEach(cart.discountCodes, id: \.code) { discount in
                            if discount.isApplicable {
                                HStack(spacing: Spacing.xxs) {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 10, weight: .bold))
                                    Text(discount.code)
                                        .trueFitTextStyle(.caption2)
                                }
                                .padding(.horizontal, Spacing.sm)
                                .padding(.vertical, 6)
                                .background(Color.semanticSuccess.opacity(0.15))
                                .foregroundColor(.semanticSuccess)
                                .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
            
            if isDiscountExpanded {
                HStack(spacing: Spacing.sm) {
                    TextField("Enter promo code", text: $viewModel.discountInput)
                        .trueFitTextStyle(.body)
                        .padding(.horizontal, Spacing.sm)
                        .frame(height: 44)
                        .background(Color.surface)
                        .clipShape(RoundedRectangle.trueFit(Radius.sm))
                        .overlay(RoundedRectangle(cornerRadius: Radius.sm).stroke(Color.borderColor, lineWidth: 1))
                        .autocapitalization(.allCharacters)
                        .submitLabel(.done)
                        .onSubmit {
                            Task { await viewModel.applyDiscount() }
                        }
                    
                    Button(action: {
                        Task { await viewModel.applyDiscount() }
                    }) {
                        ZStack {
                            if viewModel.isUpdating {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Apply")
                                    .trueFitTextStyle(.headline)
                            }
                        }
                        .foregroundColor(.white)
                        .frame(width: 80, height: 44)
                        .background(viewModel.discountInput.isEmpty ? Color.disabledColor : Color.brandPrimary)
                        .clipShape(RoundedRectangle.trueFit(Radius.sm))
                    }
                    .disabled(viewModel.discountInput.isEmpty || viewModel.isUpdating)
                }
                .padding(.top, Spacing.xs)
            }
        }
    }
}
