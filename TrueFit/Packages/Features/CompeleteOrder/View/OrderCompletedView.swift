//
//  OrderCompletedView.swift
//  TrueFit
//
//  Created by mohamed sharafeldin on 06/07/2026.
//

import SwiftUI

struct OrderCompletedView: View {
    @StateObject private var viewModel: OrderCompletedViewModel
    @EnvironmentObject var appRouter: AppRouter
    
    @State private var animateIcon = false
    
    init(viewModel: OrderCompletedViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    init(info: OrderCompletedInfo) {
        _viewModel = StateObject(wrappedValue: OrderCompletedViewModel(info: info))
    }
    
    var body: some View {
        ZStack {
            Color.trueFitBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: Spacing.xxl) {
                        
                        // 1. Success Hero Icon
                        heroIcon
                            .padding(.top, Spacing.xxxl)
                        
                        // 2. Title & Subtitle
                        titleSection
                        
                        // 3. Summary Card
                        summaryCard
                            .padding(.horizontal, Spacing.md)
                    }
                    .padding(.bottom, Spacing.xxl)
                }
                
                // 4. Bottom Action Buttons
                bottomButtons
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                animateIcon = true
            }
        }
        .trueFitToast(
            message: Binding(
                get: { viewModel.showTrackingToast ? "Tracking information sent to your email!" : nil },
                set: { if $0 == nil { viewModel.showTrackingToast = false } }
            ),
            style: .success
        )
    }
    
    // MARK: - Hero Icon
    private var heroIcon: some View {
        ZStack {
            Circle()
                .fill(Color.brandPrimary.opacity(0.12))
                .frame(width: 116, height: 116)
                .scaleEffect(animateIcon ? 1.0 : 0.5)
                .opacity(animateIcon ? 1.0 : 0.0)
            
            Circle()
                .fill(Color.brandPrimary)
                .frame(width: 80, height: 80)
                .scaleEffect(animateIcon ? 1.0 : 0.2)
                .shadow(color: Color.brandPrimary.opacity(0.3), radius: 12, x: 0, y: 6)
            
            Image(systemName: "checkmark")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
                .scaleEffect(animateIcon ? 1.0 : 0.0)
        }
    }
    
    // MARK: - Title Section
    private var titleSection: some View {
        VStack(spacing: Spacing.xs) {
            Text("Order placed.")
                .trueFitTextStyle(.largeTitle)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Thank you, Eliza. We're preparing your pieces\nand will share tracking shortly.")
                .trueFitTextStyle(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, Spacing.lg)
        }
    }
    
    // MARK: - Summary Card
    private var summaryCard: some View {
        VStack(spacing: Spacing.md) {
            summaryRow(label: "Order number", value: viewModel.info.orderNumber)
            
            Divider()
                .background(Color.borderColor)
            
            summaryRow(label: "Total", value: viewModel.info.totalAmountText)
            
            Divider()
                .background(Color.borderColor)
            
            summaryRow(label: "Estimated delivery", value: viewModel.info.estimatedDeliveryText)
            
            Divider()
                .background(Color.borderColor)
            
            summaryRow(label: "Shipping to", value: viewModel.info.shippingAddressText)
        }
        .padding(Spacing.lg)
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.xl))
        .overlay(
            RoundedRectangle.trueFit(Radius.xl)
                .stroke(Color.borderColor, lineWidth: 1)
        )
        .trueFitShadow(.sm)
    }
    
    private func summaryRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .trueFitTextStyle(.body)
                .foregroundColor(.textSecondary)
            Spacer()
            Text(value)
                .trueFitTextStyle(.headline)
                .foregroundColor(.textPrimary)
        }
    }
    
    // MARK: - Bottom Buttons
    private var bottomButtons: some View {
        VStack(spacing: Spacing.sm) {
            Button(action: {
                viewModel.trackOrder(appRouter: appRouter)
            }) {
                Text("Track order")
                    .trueFitTextStyle(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 54)
                    .background(Color.brandPrimary)
                    .clipShape(RoundedRectangle.trueFit(Radius.xl))
            }
            
            Button(action: {
                appRouter.popAllToRoot()
                appRouter.switchTab(to: .home)
            }) {
                Text("Continue shopping")
                    .trueFitTextStyle(.headline)
                    .foregroundColor(.textPrimary)
                    .frame(maxWidth: .infinity, minHeight: 54)
                    .background(Color.surface)
                    .clipShape(RoundedRectangle.trueFit(Radius.xl))
                    .overlay(
                        RoundedRectangle.trueFit(Radius.xl)
                            .stroke(Color.borderColor, lineWidth: 1.5)
                    )
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.md)
        .background(Color.trueFitBackground)
    }
}

// MARK: - Previews

struct OrderCompletedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderCompletedView(
                info: OrderCompletedInfo(
                    orderNumber: "ORD-8492",
                    totalAmountText: "$536.00",
                    estimatedDeliveryText: "Jun 26 — Jun 28",
                    shippingAddressText: "184 Linden Avenue, Brooklyn"
                )
            )
            .environmentObject(AppRouter())
        }
    }
}
