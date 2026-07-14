//
//  WelcomeAuthView.swift
//  TrueFit
//

import SwiftUI

struct WelcomeAuthView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var isTextVisible = false
    
    var body: some View {
        ZStack {
            // Background Image
            Image("welcome_image")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 3)
            
            // Dark overlay for contrast
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Modern Text Middle
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("TRUEFIT APP")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 102/255, green: 161/255, blue: 0))
                        .tracking(2)
                    
                    Text("Elevate Your Style.")
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundColor(.white)
                    
                    Text("Discover fashion tailored to you.")
                        .trueFitTextStyle(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        
                        
                    Text("Browse our exclusive collections and find the perfect outfit for any occasion, curated by our AI stylist.")
                        .trueFitTextStyle(.footnote)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top, Spacing.xs)
                        
                    Text("Join thousands of shoppers discovering their true fit today.")
                        .trueFitTextStyle(.caption)
                        .foregroundColor(Color(red: 102/255, green: 161/255, blue: 0).opacity(0.9))
                        .padding(.top, Spacing.xs)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, Spacing.xl)
                .padding(.top, 60)
                .opacity(isTextVisible ? 1 : 0)
                .offset(y: isTextVisible ? 0 : 20)
                
                Spacer().frame(height: 40)
                
                VStack(spacing: Spacing.md) {
                    let accentColor = Color(red: 102/255, green: 161/255, blue: 0)
                    
                    // Create Account Button (Primary style)
                    Button(action: {
                        viewModel.navigateToSignUp()
                    }) {
                        Text("Create Account")
                            .trueFitTextStyle(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(Spacing.md)
                            .background(accentColor)
                            .clipShape(RoundedRectangle.trueFit(Radius.xl))
                    }
                    
                    // Continue as Guest Button (Secondary style)
                    Button(action: {
                        viewModel.continueAsGuest()
                    }) {
                        Text("Continue as a Guest")
                            .trueFitTextStyle(.headline)
                            .foregroundColor(accentColor)
                            .frame(maxWidth: .infinity)
                            .padding(Spacing.md)
                            .background(
                                RoundedRectangle.trueFit(Radius.xl)
                                    .stroke(accentColor, lineWidth: 1.5)
                            )
                    }
                    
                    HStack {
                        Text("Already have an account?")
                            .trueFitTextStyle(.footnote)
                            .foregroundColor(.white.opacity(0.8))
                        Button("Log In") {
                            viewModel.navigateToSignIn()
                        }
                        .trueFitTextStyle(.footnote)
                        .foregroundColor(accentColor)
                        .fontWeight(.bold)
                    }
                    .padding(.top, Spacing.md)
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.bottom, Spacing.xxxl)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 1.0).delay(0.2)) {
                isTextVisible = true
            }
        }
    }
}

struct WelcomeAuthView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeAuthView(viewModel: PreviewMocks.makeAuthViewModel())
    }
}
