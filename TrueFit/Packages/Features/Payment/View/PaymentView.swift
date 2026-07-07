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
                navigationBar
                scrollContent
            }

            paymentStateOverlay
        }
        .navigationBarHidden(true)
    }

    private var navigationBar: some View {
        ZStack {
            Text("Payment")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.textPrimary)

            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.textPrimary)
                }
                Spacer()
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(Color.surface)
        .overlay(
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 0.5),
            alignment: .bottom
        )
    }

    private var scrollContent: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                orderSummaryCard
                applePaySection
            }
            .padding(Spacing.md)
        }
    }

    private var orderSummaryCard: some View {
        VStack(spacing: Spacing.md) {
            HStack {
                Text("Order Summary")
                    .font(.trueFitTitle3)
                    .foregroundColor(.textPrimary)
                Spacer()
            }

            Divider()
                .background(Color.borderColor)

            HStack {
                Text("Total")
                    .font(.trueFitCallout)
                    .foregroundColor(.textSecondary)
                Spacer()
                Text(viewModel.orderTotal, format: .currency(code: PaymentConfiguration.currencyCode))
                    .font(.trueFitHeadline)
                    .foregroundColor(.textPrimary)
            }
        }
        .padding(Spacing.lg)
        .background(Color.surface)
        .cornerRadius(Radius.md)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.md)
                .stroke(Color.borderColor, lineWidth: 0.5)
        )
    }

    private var applePaySection: some View {
        VStack(spacing: Spacing.md) {
            HStack {
                Text("Pay with")
                    .font(.trueFitTitle3)
                    .foregroundColor(.textPrimary)
                Spacer()
            }

            if viewModel.isApplePayAvailable {
                applePayAvailableContent
            } else {
                applePayUnavailableContent
            }
        }
        .padding(Spacing.lg)
        .background(Color.surface)
        .cornerRadius(Radius.md)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.md)
                .stroke(Color.borderColor, lineWidth: 0.5)
        )
    }

    private var applePayAvailableContent: some View {
        VStack(spacing: Spacing.sm) {
            Text("Tap the button below to complete your purchase securely with Apple Pay.")
                .font(.trueFitSubheadline)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            ApplePayButtonView(
                buttonStyle: .automatic,
                buttonType: .plain
            ) {
                guard viewModel.paymentState != .processing else { return }
                Task {
                    await viewModel.startApplePayment()
                }
            }
            .frame(height: 50)
        }
    }

    private var applePayUnavailableContent: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.semanticWarning)

            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Apple Pay Not Available")
                    .font(.trueFitCallout)
                    .fontWeight(.medium)
                    .foregroundColor(.textPrimary)

                Text("Please add a card in the Wallet app to use Apple Pay.")
                    .font(.trueFitSubheadline)
                    .foregroundColor(.textSecondary)
            }

            Spacer()
        }
        .padding(Spacing.sm)
        .background(Color.semanticWarning.opacity(0.08))
        .cornerRadius(Radius.sm)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.sm)
                .stroke(Color.semanticWarning.opacity(0.3), lineWidth: 0.5)
        )
    }

    @ViewBuilder
    private var paymentStateOverlay: some View {
        switch viewModel.paymentState {
        case .success:
            paymentResultBanner(
                icon: "checkmark.circle.fill",
                iconColor: .semanticSuccess,
                title: "Payment Successful",
                subtitle: "Your order has been placed.",
                actionTitle: "Done",
                action: { dismiss() }
            )

        case .failed(let message):
            paymentResultBanner(
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

    private func paymentResultBanner(
        icon: String,
        iconColor: Color,
        title: String,
        subtitle: String,
        actionTitle: String,
        action: @escaping () -> Void
    ) -> some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()

            VStack(spacing: Spacing.lg) {
                Image(systemName: icon)
                    .font(.system(size: 52))
                    .foregroundColor(iconColor)

                VStack(spacing: Spacing.xs) {
                    Text(title)
                        .font(.trueFitTitle2)
                        .foregroundColor(.textPrimary)

                    Text(subtitle)
                        .font(.trueFitCallout)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                }

                Button(action: action) {
                    Text(actionTitle)
                        .font(.trueFitHeadline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.sm)
                        .background(Color.brandPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: Radius.xl))
                }
            }
            .padding(Spacing.xl)
            .background(Color.surface)
            .clipShape(RoundedRectangle.trueFit(Radius.lg))
            .shadow(color: Color.shadowColor.opacity(0.2), radius: 20, x: 0, y: 10)
            .padding(.horizontal, Spacing.xxl)
            .transition(.scale(scale: 0.95).combined(with: .opacity))
        }
        .transition(.opacity)
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: viewModel.paymentState)
        .zIndex(1)
    }
}

#Preview {
    PaymentView(viewModel: PreviewMocks.makePaymentViewModel())
        .environmentObject(AppRouter())
}
