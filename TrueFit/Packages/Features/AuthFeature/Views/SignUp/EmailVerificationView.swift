//
//  EmailVerificationView.swift
//  TrueFit
//

import SwiftUI

struct EmailVerificationView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: Spacing.xl) {

            // Drag indicator
            HStack {
                Spacer()
                Capsule()
                    .fill(Color.disabledColor)
                    .frame(width: 40, height: 5)
                    .padding(.top, Spacing.md)
                Spacer()
            }

            // Icon + Title
            VStack(spacing: Spacing.lg) {
                ZStack {
                    Circle()
                        .fill(Color.brandPrimary.opacity(0.12))
                        .frame(width: 120, height: 120)
                    Circle()
                        .fill(Color.brandPrimary)
                        .frame(width: 80, height: 80)
                    Image(systemName: "envelope.badge.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 30, weight: .semibold))
                }
                .padding(.top, Spacing.sm)

                VStack(spacing: Spacing.xs) {
                    Text("Verify Your Email")
                        .trueFitTextStyle(.title2)
                        .foregroundColor(.textPrimary)

                    Text("A verification email has been sent to\n\(viewModel.email.trimmingCharacters(in: .whitespaces)).\n\nPlease check your inbox and verify your email before signing in.")
                        .trueFitTextStyle(.body)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.xl)
                }
            }

            Spacer()

            // Resend + alert
            VStack(spacing: Spacing.md) {
                PrimaryButton(title: "Resend Verification Email") {
                    viewModel.resendVerificationEmail()
                }
                .disabled(viewModel.isLoading)

                Button("Go to Sign In") {
                    dismiss()
                    viewModel.showEmailVerificationSheet = false
                    viewModel.goBack()
                }
                .trueFitTextStyle(.headline)
                .foregroundColor(.brandPrimary)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: Radius.md)
                        .stroke(Color.brandPrimary, lineWidth: 1.5)
                )
            }
            .padding(.horizontal, Spacing.md)
            .padding(.bottom, Spacing.xxl)
        }
        .overlay {
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
        .alert(viewModel.successMessage ?? viewModel.errorMessage ?? "", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {
                viewModel.successMessage = nil
                viewModel.errorMessage = nil
            }
        }
        .background(Color.surface.ignoresSafeArea())
    }
}

struct EmailVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        Color.trueFitBackground
            .ignoresSafeArea()
            .sheet(isPresented: .constant(true)) {
                EmailVerificationView(viewModel: PreviewMocks.makeAuthViewModel())
                    .presentationDetents([.height(520)])
                    .presentationDragIndicator(.hidden)
            }
    }
}
