import SwiftUI

struct ContactUsView: View {
    @EnvironmentObject var appRouter: AppRouter
    
    var body: some View {
        ZStack {
            Color.trueFitBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        // Header Image or Icon
                        VStack(spacing: Spacing.sm) {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                                .font(.system(size: 64))
                                .foregroundColor(.brandPrimary)
                            
                            Text("We're here to help")
                                .trueFitTextStyle(.title1)
                                .foregroundColor(.textPrimary)
                            
                            Text("Reach out to us through any of the following methods. We typically reply within 24 hours.")
                                .trueFitTextStyle(.body)
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, Spacing.lg)
                        }
                        .padding(.top, Spacing.xxl)
                        
                        // Contact Cards
                        VStack(spacing: Spacing.md) {
                            ContactMethodCard(
                                icon: "envelope.fill",
                                title: "Email Support",
                                detail: "support@truefit.com",
                                actionText: "Send Email",
                                action: {
                                    // Action
                                }
                            )
                            
                            ContactMethodCard(
                                icon: "phone.fill",
                                title: "Phone Support",
                                detail: "+1 (800) 123-4567",
                                actionText: "Call Us",
                                action: {
                                    // Action
                                }
                            )
                            
                            ContactMethodCard(
                                icon: "message.fill",
                                title: "Live Chat",
                                detail: "Available 9am-5pm EST",
                                actionText: "Start Chat",
                                action: {
                                    // Action
                                }
                            )
                        }
                        .padding(.horizontal, Spacing.md)
                        
                        Spacer()
                    }
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
            
            Text("Contact Us")
                .trueFitTextStyle(.title2)
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
    }
}

struct ContactMethodCard: View {
    let icon: String
    let title: String
    let detail: String
    let actionText: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                // Icon Background
                ZStack {
                    Circle()
                        .fill(Color.brandPrimary.opacity(0.1))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(.brandPrimary)
                }
                
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(title)
                        .trueFitTextStyle(.headline)
                        .foregroundColor(.textPrimary)
                    
                    Text(detail)
                        .trueFitTextStyle(.subheadline)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Text(actionText)
                    .trueFitTextStyle(.caption)
                    .foregroundColor(.brandPrimary)
                    .padding(.horizontal, Spacing.sm)
                    .padding(.vertical, Spacing.xs)
                    .background(Color.brandPrimary.opacity(0.1))
                    .clipShape(Capsule())
            }
            .padding(Spacing.md)
            .background(Color.surface)
            .clipShape(RoundedRectangle.trueFit(Radius.md))
            .trueFitShadow(.sm)
        }
    }
}
