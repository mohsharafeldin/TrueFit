//
//  PaymentView.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//

import SwiftUI

struct PaymentView: View {

    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: PaymentViewModel

    init(viewModel: PaymentViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.trueFitBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                PaymentNavigationBar(dismissAction: { dismiss() })
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        PaymentOrderSummaryCard(total: viewModel.orderTotal)
                        
                        PaymentMethodsSection(
                            selectedMethod: $viewModel.selectedPaymentMethod,
                            isApplePayAvailable: viewModel.isApplePayAvailable,
                            isProcessing: viewModel.paymentState == .processing,
                            onApplePayAction: {
                                Task { await viewModel.startApplePayment() }
                            },
                            onCashOnDeliveryAction: {
                                Task { await viewModel.startCashOnDelivery() }
                            }
                        )
                    }
                    .padding(Spacing.md)
                }
            }

            paymentStateOverlay
        }
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private var paymentStateOverlay: some View {
        Group {
            switch viewModel.paymentState {
            case .success:
                PaymentResultBanner(
                    icon: "checkmark.circle.fill",
                    iconColor: .semanticSuccess,
                    title: "Payment Successful",
                    subtitle: "Your order has been placed.",
                    actionTitle: "Done",
                    action: { dismiss() }
                )

            case .failed(let message):
                PaymentResultBanner(
                    icon: "xmark.circle.fill",
                    iconColor: .semanticDanger,
                    title: "Payment Failed",
                    subtitle: message,
                    actionTitle: "Try Again",
                    action: { viewModel.resetState() }
                )

            case .cancelled:
                EmptyView()
                    .onAppear { viewModel.resetState() }

            default:
                EmptyView()
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: viewModel.paymentState)
        .zIndex(1)
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView(viewModel: PreviewMocks.makePaymentViewModel())
            .environmentObject(AppRouter())
    }
}
