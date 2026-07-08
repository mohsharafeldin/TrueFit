import SwiftUI

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

struct FAQsView: View {
    @EnvironmentObject var appRouter: AppRouter
    
    let faqs: [FAQItem] = [
        FAQItem(question: "How do I track my order?", answer: "You can track your order using the tracking link sent to your email after your order ships, or by visiting the 'Orders' section in your profile."),
        FAQItem(question: "What is your return policy?", answer: "We offer a 30-day return policy for unused and unworn items in their original packaging. Please contact support to initiate a return."),
        FAQItem(question: "How long does shipping take?", answer: "Standard shipping typically takes 3-5 business days. Expedited shipping options are available at checkout."),
        FAQItem(question: "Can I change or cancel my order?", answer: "Orders can be modified or canceled within 1 hour of placement. After that, the order will be processed and cannot be changed."),
        FAQItem(question: "What payment methods do you accept?", answer: "We accept all major credit cards, Apple Pay, Google Pay, and PayPal.")
    ]
    
    @State private var expandedStates: [UUID: Bool] = [:]
    
    var body: some View {
        ZStack {
            Color.trueFitBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: Spacing.md) {
                        ForEach(faqs) { faq in
                            FAQCard(
                                faq: faq,
                                isExpanded: Binding(
                                    get: { expandedStates[faq.id, default: false] },
                                    set: { expandedStates[faq.id] = $0 }
                                )
                            )
                        }
                    }
                    .padding(.vertical, Spacing.xl)
                    .padding(.horizontal, Spacing.md)
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
            
            Text("FAQs")
                .trueFitTextStyle(.title2)
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
    }
}

struct FAQCard: View {
    let faq: FAQItem
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(faq.question)
                        .trueFitTextStyle(.headline)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.textSecondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(Spacing.md)
            }
            
            if isExpanded {
                Text(faq.answer)
                    .trueFitTextStyle(.body)
                    .foregroundColor(.textSecondary)
                    .padding(.horizontal, Spacing.md)
                    .padding(.bottom, Spacing.md)
            }
        }
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.md))
        .trueFitShadow(.sm)
    }
}
