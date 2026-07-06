//
//  OrderHistoryView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import SwiftUI

// MARK: - Dummy Models (Replace with actual Domain Models)
enum OrderStatus: String, CaseIterable {
    case all = "All"
    case processing = "Processing"
    case shipped = "Shipped"
    case delivered = "Delivered"
    case cancelled = "Cancelled"
    
    var color: Color {
        switch self {
        case .all: return .brandPrimary
        case .processing: return .semanticWarning ?? .orange
        case .shipped: return .brandPrimary
        case .delivered: return .semanticSuccess ?? .green
        case .cancelled: return .semanticDanger ?? .red
        }
    }
}

struct OrderMock: Identifiable {
    let id: String
    let orderNumber: String
    let date: String
    let totalAmount: Double
    let status: OrderStatus
    let itemImageURLs: [URL?]
    let totalItemsCount: Int
}

// MARK: - Order History View
struct OrderHistoryView: View {
    @EnvironmentObject var appRouter: AppRouter
    // @StateObject var viewModel: OrderHistoryViewModel
    
    // Temporary States for UI demonstration
    @State private var selectedStatus: OrderStatus = .all
    @State private var isLoading: Bool = false
    @State private var orders: [OrderMock] = PreviewData.mockOrders
    
    var filteredOrders: [OrderMock] {
        if selectedStatus == .all {
            return orders
        }
        return orders.filter { $0.status == selectedStatus }
    }
    
    var body: some View {
        ZStack {
            Color.trueFitBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Status Filter Tabs
                OrderStatusTabs(selectedStatus: $selectedStatus)
                    .padding(.vertical, Spacing.sm)
                
                // Content
                if isLoading {
                    loadingContent
                } else if filteredOrders.isEmpty {
                    OrderEmptyStateView(status: selectedStatus)
                } else {
                    ordersList
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // viewModel.loadOrders()
        }
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
            
            Text("My Orders")
                .trueFitTextStyle(.title2)
                .foregroundColor(.textPrimary)
                .bold()
            
            Spacer()
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.sm)
        .padding(.bottom, Spacing.xs)
    }
    
    // MARK: - Orders List
    private var ordersList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: Spacing.lg) {
                ForEach(filteredOrders) { order in
                    OrderHistoryCard(order: order) {
                        print("Navigate to order: \(order.orderNumber)")
                    }
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.95).combined(with: .opacity),
                        removal: .opacity
                    ))
                }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.top, Spacing.sm)
            .padding(.bottom, 100)
        }
        .animation(TrueFitMotion.springDefault, value: filteredOrders.count)
    }
    
    // MARK: - Loading Content
    private var loadingContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: Spacing.lg) {
                ForEach(0..<4, id: \.self) { _ in
                    ShimmerOrderCard()
                }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.top, Spacing.sm)
        }
    }
}

// MARK: - Order Status Tabs
struct OrderStatusTabs: View {
    @Binding var selectedStatus: OrderStatus
    @Namespace private var tabAnimation
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.sm) {
                ForEach(OrderStatus.allCases, id: \.self) { status in
                    Button(action: {
                        withAnimation(TrueFitMotion.springSnappy) {
                            selectedStatus = status
                        }
                    }) {
                        Text(status.rawValue)
                            .trueFitTextStyle(.subheadline)
                            .fontWeight(selectedStatus == status ? .semibold : .regular)
                            .foregroundColor(selectedStatus == status ? .white : .textSecondary)
                            .padding(.horizontal, Spacing.lg)
                            .padding(.vertical, Spacing.sm)
                            .background(
                                ZStack {
                                    if selectedStatus == status {
                                        RoundedRectangle.trueFit(Radius.pill)
                                            .fill(Color.brandPrimary)
                                            .matchedGeometryEffect(id: "statusTab", in: tabAnimation)
                                    } else {
                                        RoundedRectangle.trueFit(Radius.pill)
                                            .fill(Color.surface)
                                            .overlay(
                                                RoundedRectangle.trueFit(Radius.pill)
                                                    .stroke(Color.borderColor, lineWidth: 1)
                                            )
                                    }
                                }
                            )
                    }
                }
            }
            .padding(.horizontal, Spacing.lg)
        }
    }
}

// MARK: - Order History Card
struct OrderHistoryCard: View {
    let order: OrderMock
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                // Top Section: Order ID & Status
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text("Order \(order.orderNumber)")
                            .trueFitTextStyle(.headline)
                            .foregroundColor(.textPrimary)
                            .bold()
                        
                        Text(order.date)
                            .trueFitTextStyle(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Status Badge
                    Text(order.status.rawValue)
                        .trueFitTextStyle(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(order.status.color)
                        .padding(.horizontal, Spacing.sm)
                        .padding(.vertical, 6)
                        .background(order.status.color.opacity(0.12))
                        .clipShape(RoundedRectangle.trueFit(Radius.pill))
                }
                .padding(Spacing.md)
                
                Divider()
                    .background(Color.borderColor)
                    .padding(.horizontal, Spacing.md)
                
                // Middle Section: Items Images Preview & Details
                HStack(alignment: .center) {
                    OrderImagesOverlapView(imageURLs: order.itemImageURLs, totalItems: order.totalItemsCount)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.textTertiary)
                }
                .padding(Spacing.md)
                
                // Bottom Section: Total Price & CTA
                HStack {
                    Text("Total:")
                        .trueFitTextStyle(.subheadline)
                        .foregroundColor(.textSecondary)
                    
                    Text(formattedPrice)
                        .trueFitTextStyle(.title3)
                        .foregroundColor(.textPrimary)
                        .bold()
                    
                    Spacer()
                    
                    // Reorder / Details Button (Stylized)
                    Text(order.status == .delivered ? "Reorder" : "Track")
                        .trueFitTextStyle(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.brandPrimary)
                        .padding(.horizontal, Spacing.md)
                        .padding(.vertical, Spacing.xs)
                        .overlay(
                            RoundedRectangle.trueFit(Radius.pill)
                                .stroke(Color.brandPrimary, lineWidth: 1.5)
                        )
                }
                .padding(Spacing.md)
                .background(Color.trueFitBackground.opacity(0.5))
            }
            .background(Color.surface)
            .clipShape(RoundedRectangle.trueFit(Radius.lg))
            .trueFitShadow(.sm)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSDecimalNumber(value: order.totalAmount)) ?? "$\(order.totalAmount)"
    }
}

// MARK: - Overlapping Images View
struct OrderImagesOverlapView: View {
    let imageURLs: [URL?]
    let totalItems: Int
    private let maxImagesToShow = 3
    private let imageSize: CGFloat = 46
    
    var body: some View {
        HStack(spacing: -Spacing.sm) {
            ForEach(0..<min(imageURLs.count, maxImagesToShow), id: \.self) { index in
                AsyncImage(url: imageURLs[index]) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        Color.surface
                            .overlay(
                                Image(systemName: "bag.fill")
                                    .foregroundColor(.textTertiary.opacity(0.5))
                            )
                    }
                }
                .frame(width: imageSize, height: imageSize)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.surface, lineWidth: 2))
                .zIndex(Double(maxImagesToShow - index))
            }
            
            // +X More Indicator
            if totalItems > maxImagesToShow {
                ZStack {
                    Circle()
                        .fill(Color.surface)
                        .frame(width: imageSize, height: imageSize)
                        .overlay(Circle().stroke(Color.borderColor, lineWidth: 1))
                    
                    Text("+\(totalItems - maxImagesToShow)")
                        .trueFitTextStyle(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.textSecondary)
                }
                .zIndex(0)
            }
        }
    }
}

// MARK: - Empty State View
struct OrderEmptyStateView: View {
    let status: OrderStatus
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.brandPrimary.opacity(0.08))
                    .frame(width: 140, height: 140)
                
                Image(systemName: "box.truck")
                    .font(.system(size: 56, weight: .light))
                    .foregroundColor(.brandPrimary)
            }
            
            VStack(spacing: Spacing.sm) {
                Text(titleMessage)
                    .trueFitTextStyle(.title2)
                    .foregroundColor(.textPrimary)
                    .bold()
                
                Text(bodyMessage)
                    .trueFitTextStyle(.body)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xxxl)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var titleMessage: String {
        status == .all ? "No Orders Yet" : "No \(status.rawValue) Orders"
    }
    
    private var bodyMessage: String {
        status == .all
        ? "You haven't placed any orders yet. Explore our collections and find something you love!"
        : "You don't have any orders currently in \(status.rawValue.lowercased()) status."
    }
}

// MARK: - Shimmer Loading Card
struct ShimmerOrderCard: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    shimmerBlock(width: 120, height: 16)
                    shimmerBlock(width: 80, height: 12)
                }
                Spacer()
                shimmerBlock(width: 70, height: 24, cornerRadius: Radius.pill)
            }
            .padding(Spacing.md)
            
            Divider()
            
            // Middle
            HStack(spacing: -Spacing.sm) {
                ForEach(0..<3) { index in
                    shimmerBlock(width: 46, height: 46, cornerRadius: 23)
                        .overlay(Circle().stroke(Color.surface, lineWidth: 2))
                        .zIndex(Double(3 - index))
                }
                Spacer()
            }
            .padding(Spacing.md)
            
            // Bottom
            HStack {
                shimmerBlock(width: 60, height: 14)
                shimmerBlock(width: 80, height: 18)
                Spacer()
                shimmerBlock(width: 80, height: 30, cornerRadius: Radius.pill)
            }
            .padding(Spacing.md)
        }
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.lg))
        .trueFitShadow(.sm)
        .onAppear {
            withAnimation(
                .linear(duration: TrueFitMotion.loadingCycle)
                .repeatForever(autoreverses: false)
            ) {
                isAnimating = true
            }
        }
    }
    
    @ViewBuilder
    private func shimmerBlock(width: CGFloat, height: CGFloat, cornerRadius: CGFloat = 4) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.trueFitBackground)
            .frame(width: width, height: height)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white.opacity(0.4), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: isAnimating ? 200 : -200)
            )
            .clipped()
    }
}

// MARK: - Previews

#Preview("Order History") {
    NavigationView {
        OrderHistoryView()
            .environmentObject(AppRouter())
    }
}


// MARK: - Preview Data
struct PreviewData {
    static let mockOrders : [OrderMock] = [
        OrderMock(id: "1", orderNumber: "#TF-90283", date: "Oct 24, 2026 • 10:30 AM", totalAmount: 145.99, status: .processing, itemImageURLs: [URL(string: "https://example.com/1"), URL(string: "https://example.com/2")], totalItemsCount: 2),
        OrderMock(id: "2", orderNumber: "#TF-87120", date: "Oct 12, 2026 • 02:15 PM", totalAmount: 89.50, status: .shipped, itemImageURLs: [URL(string: "https://example.com/3")], totalItemsCount: 1),
        OrderMock(id: "3", orderNumber: "#TF-75211", date: "Sep 05, 2026 • 08:45 PM", totalAmount: 320.00, status: .delivered, itemImageURLs: [URL(string: "https://example.com/4"), URL(string: "https://example.com/5"), URL(string: "https://example.com/6"), URL(string: "https://example.com/7")], totalItemsCount: 5),
        OrderMock(id: "4", orderNumber: "#TF-66329", date: "Aug 20, 2026 • 11:20 AM", totalAmount: 45.00, status: .cancelled, itemImageURLs: [URL(string: "https://example.com/8")], totalItemsCount: 1)
    ]
}

