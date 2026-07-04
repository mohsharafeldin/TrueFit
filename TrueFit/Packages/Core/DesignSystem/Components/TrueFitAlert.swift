import SwiftUI

public struct TrueFitAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let primaryActionTitle: String
    let isPrimaryDestructive: Bool
    let onPrimaryAction: () -> Void
    let secondaryActionTitle: String
    let onSecondaryAction: (() -> Void)?
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                // Background scrim
                Color.overlayColor
                    .ignoresSafeArea()
                    .opacity(isPresented ? 1 : 0)
                    .onTapGesture {
                        withAnimation { isPresented = false }
                    }
                
                // Alert Box
                VStack(spacing: Spacing.lg) {
                    VStack(spacing: Spacing.xs) {
                        Text(title)
                            .trueFitTextStyle(.headline)
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)
                        
                        Text(message)
                            .trueFitTextStyle(.subheadline)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    HStack(spacing: Spacing.md) {
                        Button(action: {
                            withAnimation { isPresented = false }
                            onSecondaryAction?()
                        }) {
                            Text(secondaryActionTitle)
                                .trueFitTextStyle(.headline)
                                .foregroundColor(.textPrimary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Spacing.sm)
                                .background(Color.trueFitBackground) // Soft background for secondary
                                .clipShape(RoundedRectangle(cornerRadius: Radius.md))
                        }
                        
                        Button(action: {
                            withAnimation { isPresented = false }
                            onPrimaryAction()
                        }) {
                            Text(primaryActionTitle)
                                .trueFitTextStyle(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Spacing.sm)
                                .background(isPrimaryDestructive ? Color.semanticDanger : Color.brandPrimary)
                                .clipShape(RoundedRectangle(cornerRadius: Radius.md))
                        }
                    }
                }
                .padding(Spacing.xl)
                .background(Color.surface)
                .clipShape(RoundedRectangle.trueFit(Radius.lg))
                .shadow(color: Color.shadowColor.opacity(0.2), radius: 20, x: 0, y: 10)
                .padding(.horizontal, Spacing.xxl)
                .transition(.scale(scale: 0.95).combined(with: .opacity))
                .zIndex(1)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
    }
}

public extension View {
    func trueFitAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        primaryActionTitle: String,
        isPrimaryDestructive: Bool = false,
        onPrimaryAction: @escaping () -> Void,
        secondaryActionTitle: String = "Cancel",
        onSecondaryAction: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            TrueFitAlertModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                primaryActionTitle: primaryActionTitle,
                isPrimaryDestructive: isPrimaryDestructive,
                onPrimaryAction: onPrimaryAction,
                secondaryActionTitle: secondaryActionTitle,
                onSecondaryAction: onSecondaryAction
            )
        )
    }
}
