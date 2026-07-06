import SwiftUI

struct ProfileSupportSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ProfileSectionHeader(title: "Support & Info")
            
            VStack(spacing: 0) {
                ProfileRow(icon: "questionmark.circle", title: "FAQs") {
                    // Navigate to FAQs
                }
                Divider().padding(.leading, 48)
                
                ProfileRow(icon: "envelope", title: "Contact Us") {
                    // Navigate to Contact
                }
                Divider().padding(.leading, 48)
                
                ProfileRow(icon: "doc.text", title: "Terms & Conditions") {
                    // Navigate to Terms
                }
            }
            .background(Color.surface)
            .clipShape(RoundedRectangle.trueFit(Radius.md))
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .padding(.horizontal, Spacing.md)
        }
    }
}
