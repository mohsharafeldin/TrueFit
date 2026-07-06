import SwiftUI

struct CartLineRow: View {
    let line: CartLine
    @ObservedObject var viewModel: CartViewModel
    @State private var showingDeleteAlert = false
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Hidden Delete Button (Revealed on Swipe)
            Button(action: {
                showingDeleteAlert = true
            }) {
                VStack {
                    Image(systemName: "trash")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                .frame(width: 72, height: 72) // Match image height
                .background(Color.semanticDanger)
                .clipShape(RoundedRectangle(cornerRadius: Radius.md))
            }
            .padding(.trailing, Spacing.md)
            
            // Main Content Row
            HStack(alignment: .top, spacing: Spacing.md) {
                // Product Image
                AsyncImage(url: line.imageURL) { phase in
                    switch phase {
                    case .empty:
                        RoundedRectangle(cornerRadius: Radius.md)
                            .fill(Color.borderColor)
                            .overlay(ProgressView())
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        RoundedRectangle(cornerRadius: Radius.md)
                            .fill(Color.borderColor)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.textTertiary)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle.trueFit(Radius.md))
                .accessibilityLabel(line.imageAltText ?? line.productTitle)
                
                // Right Side Columns
                HStack(alignment: .top, spacing: Spacing.xs) {
                    // Info Column
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text(line.productTitle)
                            .trueFitTextStyle(.subheadline)
                            .foregroundColor(.textPrimary)
                            .lineLimit(2)
                        
                        if line.variantTitle != "Default Title", !line.variantTitle.isEmpty {
                            Text(line.variantTitle)
                                .trueFitTextStyle(.footnote)
                                .foregroundColor(.textSecondary)
                        }
                        
                        HStack(alignment: .firstTextBaseline, spacing: Spacing.xs) {
                            Text(line.lineTotal.formatted)
                                .trueFitTextStyle(.headline)
                                .foregroundColor(.textPrimary)
                                .accessibilitySortPriority(1)
                            
                            if let compareAt = line.compareAtLineTotal, line.isOnSale {
                                Text(compareAt.formatted)
                                    .trueFitTextStyle(.footnote)
                                    .foregroundColor(.textSecondary)
                                    .strikethrough()
                                    .accessibilitySortPriority(0)
                            }
                        }
                        .padding(.top, Spacing.xxs)
                        
                        if line.isOnSale {
                            Text("SALE")
                                .trueFitTextStyle(.caption2)
                                .foregroundColor(.textPrimary) // rule: use textPrimary on brandSecondary
                                .padding(.horizontal, Spacing.xs)
                                .padding(.vertical, Spacing.xxs)
                                .background(Color.brandSecondary)
                                .clipShape(Capsule())
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                    // Action Column
                    VStack(alignment: .trailing, spacing: Spacing.md) {
                        TrueFitStepper(
                            quantity: line.quantity,
                            onIncrement: {
                                Task { await viewModel.updateQuantity(lineId: line.id, quantity: line.quantity + 1) }
                            },
                            onDecrement: {
                                Task { await viewModel.updateQuantity(lineId: line.id, quantity: line.quantity - 1) }
                            },
                            isDisabled: viewModel.isUpdating
                        )
                    }
                }
            }
            .padding(.horizontal, Spacing.md)
            .background(Color.trueFitBackground) // Must have solid background to hide the button beneath it
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width < 0 {
                            // Swiping left
                            offset = max(value.translation.width, -100)
                        } else if offset < 0 {
                            // Swiping right from opened state
                            offset = min(0, -90 + value.translation.width)
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            if offset < -45 {
                                offset = -90 // Lock open
                            } else {
                                offset = 0 // Snap closed
                            }
                        }
                    }
            )
        }
        .trueFitAlert(
            isPresented: $showingDeleteAlert,
            title: "Remove Item?",
            message: "Are you sure you want to remove \(line.productTitle) from your cart?",
            primaryActionTitle: "Remove",
            isPrimaryDestructive: true,
            onPrimaryAction: {
                Task {
                    await viewModel.removeLine(lineId: line.id)
                }
            },
            onSecondaryAction: {
                withAnimation(.spring()) { offset = 0 } // Close swipe on cancel
            }
        )
    }
}
