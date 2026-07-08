import SwiftUI

struct ProfileSupportSection: View {
    @EnvironmentObject var appRouter: AppRouter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ProfileSectionHeader(title: "Support & Info")
            
            VStack(spacing: 0) {
                ProfileRow(icon: "questionmark.circle", title: "FAQs") {
                    appRouter.navigate(to: .faqs)
                }
                Divider().padding(.leading, 48)
                
                ProfileRow(icon: "envelope", title: "Contact Us") {
                    appRouter.navigate(to: .contactUs)
                }
                Divider().padding(.leading, 48)
                
                ProfileRow(icon: "doc.text", title: "Terms & Conditions") {
                    appRouter.navigate(to: .termsAndConditions)
                }
            }
            .background(Color.surface)
            .clipShape(RoundedRectangle.trueFit(Radius.md))
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .padding(.horizontal, Spacing.md)
        }
    }
}
