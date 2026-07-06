//
//  CheckoutView.swift
//  TrueFit
//
//  Created by mohamed sharafeldin on 06/07/2026.
//

import SwiftUI

struct CheckoutView: View {
    @StateObject private var viewModel: CheckoutViewModel
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var globalCartState: CartState
    
    init(viewModel: CheckoutViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.trueFitBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        
                        // Step Progress Bar
                        stepProgressBar
                            .padding(.top, Spacing.md)
                            .padding(.horizontal, Spacing.md)
                        
                        // 1. Shipping Address Section
                        shippingAddressSection
                            .padding(.horizontal, Spacing.md)
                        
                        // 2. Delivery Section
                        deliverySection
                            .padding(.horizontal, Spacing.md)
                        
                        // 3. Payment Section
                        paymentSection
                            .padding(.horizontal, Spacing.md)
                            .padding(.bottom, Spacing.xl)
                    }
                }
                
                // Bottom Checkout Bar
                bottomBar
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadCartData()
        }
    }
    
    // MARK: - Step Progress Bar
    private var stepProgressBar: some View {
        HStack(spacing: Spacing.xs) {
            // Step 1: BAG
            HStack(spacing: Spacing.xxs) {
                Circle()
                    .fill(Color.brandPrimary)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                    )
                Text("BAG")
                    .trueFitTextStyle(.caption)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
            }
            .fixedSize(horizontal: true, vertical: false)
            
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
            
            // Step 2: DETAILS (Active)
            HStack(spacing: Spacing.xxs) {
                Circle()
                    .fill(Color.textPrimary)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Text("2")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.surface)
                    )
                Text("DETAILS")
                    .trueFitTextStyle(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
            }
            .fixedSize(horizontal: true, vertical: false)
            
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
            
            // Step 3: DONE
            HStack(spacing: Spacing.xxs) {
                Circle()
                    .fill(Color.borderColor)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Text("3")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.textSecondary)
                    )
                Text("DONE")
                    .trueFitTextStyle(.caption)
                    .foregroundColor(.textTertiary)
                    .lineLimit(1)
            }
            .fixedSize(horizontal: true, vertical: false)
        }
    }
    
    // MARK: - Shipping Address Section
    private var shippingAddressSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.textPrimary)
                Text("Shipping address")
                    .trueFitTextStyle(.title3)
                    .foregroundColor(.textPrimary)
            }
            
            VStack(alignment: .leading, spacing: Spacing.md) {
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(viewModel.shippingName)
                        .trueFitTextStyle(.headline)
                        .foregroundColor(.textPrimary)
                    
                    Text(viewModel.formattedShippingAddress)
                        .trueFitTextStyle(.body)
                        .foregroundColor(.textSecondary)
                        .lineSpacing(4)
                }
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.toggleAddress()
                    }
                }) {
                    Text("Change address")
                        .trueFitTextStyle(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.brandPrimary)
                }
            }
            .padding(Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.surface)
            .clipShape(RoundedRectangle.trueFit(Radius.lg))
            .overlay(
                RoundedRectangle.trueFit(Radius.lg)
                    .stroke(Color.borderColor, lineWidth: 1)
            )
            .trueFitShadow(.xs)
        }
    }
    
    // MARK: - Delivery Section
    private var deliverySection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: "shippingbox")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.textPrimary)
                Text("Delivery")
                    .trueFitTextStyle(.title3)
                    .foregroundColor(.textPrimary)
            }
            
            VStack(spacing: Spacing.sm) {
                ForEach(viewModel.deliveryOptions) { option in
                    let isSelected = viewModel.selectedDeliveryOption == option
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.selectedDeliveryOption = option
                        }
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(option.title)
                                    .trueFitTextStyle(.headline)
                                    .foregroundColor(.textPrimary)
                                Text(option.subtitle)
                                    .trueFitTextStyle(.footnote)
                                    .foregroundColor(.textSecondary)
                            }
                            
                            Spacer()
                            
                            Text(option.priceText)
                                .trueFitTextStyle(.headline)
                                .foregroundColor(.textPrimary)
                        }
                        .padding(.vertical, Spacing.md)
                        .padding(.horizontal, Spacing.lg)
                        .background(isSelected ? Color.brandPrimary.opacity(0.06) : Color.surface)
                        .clipShape(RoundedRectangle.trueFit(Radius.lg))
                        .overlay(
                            RoundedRectangle.trueFit(Radius.lg)
                                .stroke(isSelected ? Color.brandPrimary : Color.borderColor, lineWidth: isSelected ? 2 : 1)
                        )
                        .trueFitShadow(isSelected ? .sm : .xs)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // MARK: - Payment Section
    private var paymentSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: "creditcard")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.textPrimary)
                Text("Payment")
                    .trueFitTextStyle(.title3)
                    .foregroundColor(.textPrimary)
            }
            
            VStack(spacing: Spacing.sm) {
                ForEach(viewModel.paymentMethods) { method in
                    let isSelected = viewModel.selectedPaymentMethod == method
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.selectedPaymentMethod = method
                        }
                    }) {
                        HStack(spacing: Spacing.sm) {
                            Image(systemName: method.iconName)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(isSelected ? .brandPrimary : .textSecondary)
                                .frame(width: 28)
                            
                            Text(method.title)
                                .trueFitTextStyle(.headline)
                                .foregroundColor(.textPrimary)
                            
                            Spacer()
                            
                            if isSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(.brandPrimary)
                            } else {
                                Circle()
                                    .stroke(Color.borderColor, lineWidth: 1.5)
                                    .frame(width: 22, height: 22)
                            }
                        }
                        .padding(.vertical, Spacing.md)
                        .padding(.horizontal, Spacing.lg)
                        .background(isSelected ? Color.brandPrimary.opacity(0.06) : Color.surface)
                        .clipShape(RoundedRectangle.trueFit(Radius.lg))
                        .overlay(
                            RoundedRectangle.trueFit(Radius.lg)
                                .stroke(isSelected ? Color.brandPrimary : Color.borderColor, lineWidth: isSelected ? 2 : 1)
                        )
                        .trueFitShadow(isSelected ? .sm : .xs)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // MARK: - Bottom Bar
    private var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.borderColor)
                .shadow(color: Color.shadowColor.opacity(0.05), radius: 4, x: 0, y: -2)
            
            VStack(spacing: Spacing.md) {
                HStack {
                    Text("Total")
                        .trueFitTextStyle(.body)
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Text(viewModel.totalAmountText)
                        .trueFitTextStyle(.title1)
                        .foregroundColor(.textPrimary)
                }
                
                Button(action: {
                    viewModel.placeOrder(appRouter: appRouter, cartState: globalCartState)
                }) {
                    HStack(spacing: Spacing.xs) {
                        if viewModel.isPlacingOrder {
                            ProgressView()
                                .tint(.white)
                            Text("Processing...")
                        } else {
                            Text("Place order")
                        }
                    }
                    .trueFitTextStyle(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 54)
                    .background(viewModel.isPlacingOrder ? Color.disabledColor : Color.brandPrimary)
                    .clipShape(RoundedRectangle.trueFit(Radius.xl))
                }
                .disabled(viewModel.isPlacingOrder)
            }
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.md)
            .background(Color.trueFitBackground)
        }
    }
}

// MARK: - Previews

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CheckoutView(viewModel: CheckoutViewModel())
                .environmentObject(AppRouter())
                .environmentObject(CartState())
        }
    }
}
