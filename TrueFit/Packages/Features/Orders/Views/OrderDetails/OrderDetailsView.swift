//
//  OrderDetailsView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import SwiftUI

// MARK: - Order Details View
struct OrderDetailsView: View {
    @EnvironmentObject var appRouter: AppRouter
    @StateObject var viewModel: OrderDetailsViewModel
    
    var body: some View {
        ZStack {
            Color.trueFitBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                if let orderDetails = viewModel.orderDetails {
                    headerView(orderDetails: orderDetails)
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: Spacing.lg) {
                        if viewModel.isLoading {
                            ProgressView()
                                .padding(.top, 40)
                        } else if let orderDetails = viewModel.orderDetails {
                            // Timeline & Status
                            OrderStatusTimeline(currentStatus: orderDetails.status)
                                .padding(.top, Spacing.sm)
                            
                            // Items List
                            itemsSection(orderDetails: orderDetails)
                            
                            // Payment & Shipping Info
                            infoSection(orderDetails: orderDetails)
                            
                            // Order Summary
                            summarySection(orderDetails: orderDetails)
                        } else if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.semanticDanger)
                                .padding(.top, 40)
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.bottom, Spacing.xxl * 2)
                }
            }
            
            // Floating CTA at the bottom
            if let orderDetails = viewModel.orderDetails {
                floatingBottomBar(orderDetails: orderDetails)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    // MARK: - Header
    private func headerView(orderDetails: OrderDetails) -> some View {
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
    private func itemsSection(orderDetails: OrderDetails) -> some View {
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
    
    // MARK: - Info Section
    private func infoSection(orderDetails: OrderDetails) -> some View {
        HStack(spacing: Spacing.md) {
            InfoBoxView(
                icon: "creditcard.fill",
                title: "Payment",
                value: orderDetails.paymentMethod
            )
            
            InfoBoxView(
                icon: "map.fill",
                title: "Shipping To",
                value: orderDetails.shippingAddress
            )
        }
    }
    
    // MARK: - Summary Section
    private func summarySection(orderDetails: OrderDetails) -> some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Payment Summary")
                .trueFitTextStyle(.headline)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: Spacing.sm) {
                summaryRow(title: "Subtotal", value: formatPrice(orderDetails.subtotal))
                summaryRow(title: "Shipping Fee", value: formatPrice(orderDetails.shippingFee))
                
                if orderDetails.discount > 0 {
                    summaryRow(title: "Discount", value: "-\(formatPrice(orderDetails.discount))")
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
    
    private func summaryRow(title: String, value: String, isTotal: Bool = false) -> some View {
        HStack {
            Text(title)
                .trueFitTextStyle(.subheadline)
                .foregroundColor(.textSecondary)
            Spacer()
            Text(value)
                .trueFitTextStyle(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.textPrimary)
        }
    }
    
    // MARK: - Floating Bottom Bar
    private func floatingBottomBar(orderDetails: OrderDetails) -> some View {
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

// MARK: - Previews
#if DEBUG
struct OrderDetailsView_Previews: PreviewProvider {
    static var previews: some View {

        OrderDetailsView(viewModel: PreviewMocks.makeOrderDetailsViewModel(orderId: OrderPreviewData.mockOrderDetails.orderNumber))
            .environmentObject(AppRouter())

    }
}
#endif

