import SwiftUI

public struct TrueFitStepper: View {
    let quantity: Int
    let maxQuantity: Int?
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    var isDisabled: Bool = false
    
    public init(
        quantity: Int,
        maxQuantity: Int? = nil,
        onIncrement: @escaping () -> Void,
        onDecrement: @escaping () -> Void,
        isDisabled: Bool = false
    ) {
        self.quantity = quantity
        self.maxQuantity = maxQuantity
        self.onIncrement = onIncrement
        self.onDecrement = onDecrement
        self.isDisabled = isDisabled
    }
    
    public var body: some View {
        HStack(spacing: Spacing.xs) {
            Button(action: onDecrement) {
                Image(systemName: "minus")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(quantity <= 1 || isDisabled ? .disabledColor : .textPrimary)
                    .frame(width: 20, height: 20)
            }
            .disabled(quantity <= 1 || isDisabled)
            
            Text("\(quantity)")
                .trueFitTextStyle(.footnote)
                .fontWeight(.bold)
                .frame(minWidth: 16)
                .multilineTextAlignment(.center)
            
            Button(action: onIncrement) {
                Image(systemName: "plus")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(isAtMax || isDisabled ? .disabledColor : .textPrimary)
                    .frame(width: 20, height: 20)
            }
            .disabled(isAtMax || isDisabled)
        }
        .padding(.horizontal, Spacing.xs)
        .padding(.vertical, 4)
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.pill))
        .trueFitShadow(.xs)
    }
    
    private var isAtMax: Bool {
        if let max = maxQuantity {
            return quantity >= max
        }
        return false
    }
}
