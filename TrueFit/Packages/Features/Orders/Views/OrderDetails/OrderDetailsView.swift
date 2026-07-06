//
//  OrderDetailsView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import SwiftUI

// MARK: - Dummy Models
struct OrderItemMock: Identifiable {
    let id: String
    let title: String
    let variant: String
    let price: Double
    let quantity: Int
    let imageURL: URL?
}

struct OrderDetailsMock {
    let orderNumber: String
    let date: String
    let status: OrderStatus
    let items: [OrderItemMock]
    let subtotal: Double
    let shippingFee: Double
    let discount: Double
    let total: Double
    let shippingAddress: String
    let paymentMethod: String
}

// MARK: - Order Details View
struct OrderDetailsView: View {
    @EnvironmentObject var appRouter: AppRouter
    // @StateObject var viewModel: OrderDetailsViewModel
    
    // Mock Data for UI
    let orderDetails = PreviewData.mockOrderDetails
    
    var body: some View {
        ZStack {
            Color.trueFitBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: Spacing.xl) {
                        // Top Section: Status Timeline
                        OrderStatusTimeline(currentStatus: orderDetails.status)
                            .padding(.top, Spacing.sm)
                        
                        // Items List
                        itemsSection
                        
                        // Shipping & Payment Info
                        infoSection
                        
                        // Receipt / Payment Summary
                        paymentSummarySection
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.bottom, 120)
                }
            }
            
            // Floating CTA at the bottom
            floatingBottomBar
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Header
    private var headerView: some View {
        HStack(spacing: Spacing.md) {
            Button(action: {
                appRouter.goBack()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .frame(width: 40, height: 40)
                    .background(Color.surface)
                    .clipShape(Circle())
                    .trueFitShadow(.xs)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(orderDetails.orderNumber)
                    .trueFitTextStyle(.title3)
                    .foregroundColor(.textPrimary)
                    .bold()
                
                Text(orderDetails.date)
                    .trueFitTextStyle(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            // Status Badge (Top Right)
            Text(orderDetails.status.rawValue)
                .trueFitTextStyle(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(orderDetails.status.color)
                .padding(.horizontal, Spacing.sm)
                .padding(.vertical, 6)
                .background(orderDetails.status.color.opacity(0.12))
                .clipShape(RoundedRectangle.trueFit(Radius.pill))
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.sm)
        .padding(.bottom, Spacing.sm)
        .background(Color.trueFitBackground)
    }
    
    // MARK: - Items Section
    private var itemsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Items (\(orderDetails.items.count))")
                .trueFitTextStyle(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.md) {
                ForEach(orderDetails.items) { item in
                    OrderItemCard(item: item)
                }
            }
        }
    }
    
    // MARK: - Info Section (Shipping & Payment)
    private var infoSection: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            // Shipping Box
            InfoBoxView(
                icon: "mappin.and.ellipse",
                title: "Delivery Address",
                value: orderDetails.shippingAddress
            )
            
            // Payment Box
            InfoBoxView(
                icon: "creditcard.fill",
                title: "Payment Method",
                value: orderDetails.paymentMethod
            )
        }
    }
    
    // MARK: - Payment Summary
    private var paymentSummarySection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Payment Summary")
                .trueFitTextStyle(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.sm) {
                summaryRow(title: "Subtotal", amount: orderDetails.subtotal)
                summaryRow(title: "Shipping Fee", amount: orderDetails.shippingFee)
                
                if orderDetails.discount > 0 {
                    summaryRow(title: "Discount", amount: -orderDetails.discount, textColor: .brandPrimary)
                }
                
                Divider()
                    .background(Color.borderColor)
                    .padding(.vertical, Spacing.xs)
                
                HStack {
                    Text("Total Amount")
                        .trueFitTextStyle(.title3)
                        .foregroundColor(.textPrimary)
                        .bold()
                    
                    Spacer()
                    
                    Text(formatPrice(orderDetails.total))
                        .trueFitTextStyle(.title3)
                        .foregroundColor(.brandPrimary)
                        .bold()
                }
            }
            .padding(Spacing.lg)
            .background(Color.surface)
            .clipShape(RoundedRectangle.trueFit(Radius.lg))
            .overlay(
                RoundedRectangle.trueFit(Radius.lg)
                    .stroke(Color.borderColor.opacity(0.5), lineWidth: 1)
            )
        }
    }
    
    private func summaryRow(title: String, amount: Double, textColor: Color = .textPrimary) -> some View {
        HStack {
            Text(title)
                .trueFitTextStyle(.subheadline)
                .foregroundColor(.textSecondary)
            Spacer()
            Text(formatPrice(amount))
                .trueFitTextStyle(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(textColor)
        }
    }
    
    // MARK: - Floating Bottom Bar
    private var floatingBottomBar: some View {
        VStack {
            Spacer()
            
            HStack(spacing: Spacing.md) {
                // Secondary Action
                Button(action: {
                    print("Secondary action tapped")
                }) {
                    Image(systemName: orderDetails.status == .delivered ? "arrow.down.doc" : "questionmark.circle")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.brandPrimary)
                        .frame(width: 56, height: 56)
                        .background(Color.surface)
                        .clipShape(RoundedRectangle.trueFit(Radius.lg))
                        .overlay(
                            RoundedRectangle.trueFit(Radius.lg)
                                .stroke(Color.brandPrimary, lineWidth: 1.5)
                        )
                }
                
                // Primary Action (Track or Reorder)
                Button(action: {
                    print("Primary action tapped")
                }) {
                    HStack {
                        Text(orderDetails.status == .delivered ? "Reorder All" : "Track Order")
                            .trueFitTextStyle(.headline)
                        
                        Image(systemName: orderDetails.status == .delivered ? "arrow.triangle.2.circlepath" : "location.circle.fill")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 56)
                    .background(Color.brandPrimary)
                    .clipShape(RoundedRectangle.trueFit(Radius.lg))
                    .trueFitShadow(.md)
                }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.top, Spacing.md)
            .padding(.bottom, Spacing.xl)
            .background(
                LinearGradient(
                    colors: [Color.trueFitBackground.opacity(0), Color.trueFitBackground],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
        }
    }
    
    private func formatPrice(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSDecimalNumber(value: amount)) ?? "$\(amount)"
    }
}

// MARK: - Order Item Card
struct OrderItemCard: View {
    let item: OrderItemMock
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            AsyncImage(url: item.imageURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Color.trueFitBackground
                        .overlay(Image(systemName: "photo").foregroundColor(.textTertiary))
                }
            }
            .frame(width: 75, height: 75)
            .clipShape(RoundedRectangle.trueFit(Radius.md))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .trueFitTextStyle(.body)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text(item.variant)
                    .trueFitTextStyle(.caption)
                    .foregroundColor(.textSecondary)
                
                HStack {
                    Text(formatPrice(item.price))
                        .trueFitTextStyle(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.brandPrimary)
                    
                    Spacer()
                    
                    Text("Qty: \(item.quantity)")
                        .trueFitTextStyle(.caption)
                        .foregroundColor(.textPrimary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.trueFitBackground)
                        .clipShape(RoundedRectangle.trueFit(Radius.sm))
                }
                .padding(.top, 4)
            }
        }
        .padding(Spacing.sm)
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.lg))
        .trueFitShadow(.xs)
    }
    
    private func formatPrice(_ amount: Double) -> String {
        "$\(String(format: "%.2f", amount))"
    }
}

// MARK: - Order Status Timeline (Stepper)
struct OrderStatusTimeline: View {
    let currentStatus: OrderStatus
    private let steps = ["Placed", "Processing", "Shipped", "Delivered"]
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            HStack(spacing: 0) {
                ForEach(0..<steps.count, id: \.self) { index in
                    let step = steps[index]
                    let isActive = isStepActive(step: step)
                    let isLast = index == steps.count - 1
                    
                    HStack(spacing: 0) {
                        // Icon Circle
                        ZStack {
                            Circle()
                                .fill(isActive ? Color.brandPrimary : Color.trueFitBackground)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle().stroke(isActive ? Color.clear : Color.borderColor, lineWidth: 1)
                                )
                            
                            Image(systemName: getIcon(for: step, isActive: isActive))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(isActive ? .white : .textTertiary)
                        }
                        
                        // Connecting Line
                        if !isLast {
                            Rectangle()
                                .fill(isActive && isLineActive(step: step) ? Color.brandPrimary : Color.borderColor)
                                .frame(height: 2)
                        }
                    }
                }
            }
            
            // Labels
            HStack {
                ForEach(steps, id: \.self) { step in
                    Text(step)
                        .trueFitTextStyle(.caption2)
                        .fontWeight(isStepActive(step: step) ? .semibold : .regular)
                        .foregroundColor(isStepActive(step: step) ? .textPrimary : .textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(Spacing.lg)
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.lg))
        .trueFitShadow(.xs)
    }
    
    private func isStepActive(step: String) -> Bool {
        if currentStatus == .cancelled { return false }
        let currentIndex = steps.firstIndex(of: currentStatus.rawValue) ?? 0
        let stepIndex = steps.firstIndex(of: step) ?? 0
        return stepIndex <= currentIndex
    }
    
    private func isLineActive(step: String) -> Bool {
        if currentStatus == .cancelled { return false }
        let currentIndex = steps.firstIndex(of: currentStatus.rawValue) ?? 0
        let stepIndex = steps.firstIndex(of: step) ?? 0
        return stepIndex < currentIndex
    }
    
    private func getIcon(for step: String, isActive: Bool) -> String {
        guard isActive else { return "circle.fill" }
        switch step {
        case "Placed": return "bag.fill"
        case "Processing": return "gearshape.fill"
        case "Shipped": return "box.truck.fill"
        case "Delivered": return "checkmark"
        default: return "circle.fill"
        }
    }
}

// MARK: - Info Box View (Shipping/Payment)
struct InfoBoxView: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: icon)
                    .foregroundColor(.textTertiary)
                Text(title)
                    .trueFitTextStyle(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Text(value)
                .trueFitTextStyle(.subheadline)
                .foregroundColor(.textPrimary)
                .fontWeight(.medium)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.md)
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.lg))
        .trueFitShadow(.xs)
    }
}

// MARK: - Preview Extensions & Data
extension PreviewData {
    static let mockOrderDetails = OrderDetailsMock(
        orderNumber: "#TF-75211",
        date: "Sep 05, 2026 • 08:45 PM",
        status: .shipped,
        items: [
            OrderItemMock(id: "p1", title: "Nike Air Max 270", variant: "Size: 42 | Color: White", price: 150.00, quantity: 1, imageURL: URL(string: "https://example.com/shoe1")),
            OrderItemMock(id: "p2", title: "Adidas UltraBoost", variant: "Size: 41 | Color: Core Black", price: 180.00, quantity: 2, imageURL: URL(string: "https://example.com/shoe2"))
        ],
        subtotal: 510.00,
        shippingFee: 15.00,
        discount: 25.00,
        total: 500.00,
        shippingAddress: "123 Main Street, Apt 4B, New York, NY 10001",
        paymentMethod: "**** **** **** 4242\nApple Pay"
    )
}

// MARK: - #Preview
#Preview("Order Details - In Progress") {
    OrderDetailsView()
        .environmentObject(AppRouter())
}
