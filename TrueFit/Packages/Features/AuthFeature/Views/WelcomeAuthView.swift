//
//  WelcomeAuthView.swift
//  TrueFit
//

import SwiftUI

struct WelcomeAuthView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()
            
            // App Logo
            Image(systemName: "bag.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.brandPrimary)
                .padding(.bottom, Spacing.lg)
            
            VStack(alignment: .center, spacing: Spacing.xs) {
                Text("Welcome to TrueFit")
                    .trueFitTextStyle(.title1)
                    .foregroundColor(.textPrimary)
                
                Text("Discover the best products tailored just for you.")
                    .trueFitTextStyle(.subheadline)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
            }
            
            Spacer()
            
            VStack(spacing: Spacing.md) {
                PrimaryButton(title: "Create Account") {
                    viewModel.navigateToSignUp()
                }
                
                Button(action: {
                    viewModel.continueAsGuest()
                }) {
                    Text("Continue as a Guest")
                        .trueFitTextStyle(.headline)
                        .foregroundColor(.brandPrimary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: Radius.md)
                                .stroke(Color.brandPrimary, lineWidth: 1.5)
                        )
                }
                
                HStack {
                    Text("Already have an account?")
                        .trueFitTextStyle(.footnote)
                        .foregroundColor(.textSecondary)
                    Button("Log In") {
                        viewModel.navigateToSignIn()
                    }
                    .trueFitTextStyle(.footnote)
                    .foregroundColor(.brandPrimary)
                    .fontWeight(.semibold)
                }
                .padding(.top, Spacing.md)
            }
            .padding(.horizontal, Spacing.md)
            .padding(.bottom, Spacing.xxxl)
        }
        .background(
            Color.trueFitBackground
                .ignoresSafeArea()
        )
        .navigationBarBackButtonHidden(true)
    }
}

struct WelcomeAuthView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeAuthView(viewModel: PreviewMocks.makeAuthViewModel())
    }
}
