//
//  OrderHistoryView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import SwiftUI

// MARK: - Order History View
struct OrderHistoryView: View {
    @EnvironmentObject var appRouter: AppRouter
    // @StateObject var viewModel: OrderHistoryViewModel
    
    // Temporary States for UI demonstration
    @State private var selectedStatus: OrderStatus = .all
    @State private var isLoading: Bool = false
    @State private var orders: [Order] = OrderPreviewData.mockOrders
    
    var filteredOrders: [Order] {
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

// MARK: - Previews
#Preview("Order History") {
    NavigationView {
        OrderHistoryView()
            .environmentObject(AppRouter())
    }
}
