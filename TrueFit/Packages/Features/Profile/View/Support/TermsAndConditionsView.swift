import SwiftUI

struct TermsAndConditionsView: View {
    @EnvironmentObject var appRouter: AppRouter
    
    var body: some View {
        ZStack {
            Color.trueFitBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(alignment: .leading, spacing: Spacing.xl) {
                        
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Terms and Conditions")
                                .trueFitTextStyle(.title1)
                                .foregroundColor(.textPrimary)
                            
                            Text("Last updated: August 2026")
                                .trueFitTextStyle(.subheadline)
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.top, Spacing.lg)
                        
                        VStack(alignment: .leading, spacing: Spacing.md) {
                            TermSection(
                                title: "1. Introduction",
                                content: "Welcome to TrueFit. These Terms and Conditions govern your use of our mobile application and the services we provide. By accessing or using our app, you agree to be bound by these terms."
                            )
                            
                            TermSection(
                                title: "2. User Accounts",
                                content: "You must create an account to use certain features. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account."
                            )
                            
                            TermSection(
                                title: "3. Purchases and Payments",
                                content: "All purchases are subject to our pricing and payment terms. We reserve the right to refuse or cancel any orders if we suspect fraudulent activity."
                            )
                            
                            TermSection(
                                title: "4. Intellectual Property",
                                content: "All content, logos, and materials provided in the TrueFit app are the property of TrueFit and are protected by applicable intellectual property laws."
                            )
                            
                            TermSection(
                                title: "5. Limitation of Liability",
                                content: "TrueFit shall not be liable for any indirect, incidental, special, or consequential damages arising out of your use of our application."
                            )
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.bottom, Spacing.xxxl)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
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
            
            Text("Terms")
                .trueFitTextStyle(.title2)
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
    }
}

struct TermSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(title)
                .trueFitTextStyle(.headline)
                .foregroundColor(.textPrimary)
            
            Text(content)
                .trueFitTextStyle(.body)
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
        }
    }
}
