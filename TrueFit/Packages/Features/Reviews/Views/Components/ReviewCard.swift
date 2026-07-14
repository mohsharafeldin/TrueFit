import SwiftUI

struct ReviewCard: View {
    let review: ReviewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(alignment: .top, spacing: Spacing.sm) {
                // Avatar Placeholder
                Circle()
                    .fill(Color.borderColor)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(review.author.prefix(1)))
                            .trueFitTextStyle(.headline)
                            .foregroundColor(.textSecondary)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(review.author)
                        .trueFitTextStyle(.headline)
                        .foregroundColor(.textPrimary)
                    
                    HStack(spacing: 2) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < review.rating ? "star.fill" : "star")
                                .foregroundColor(.statusRating)
                                .font(.system(size: 10))
                        }
                    }
                }
                
                Spacer()
                
                Text(review.date)
                    .trueFitTextStyle(.caption)
                    .foregroundColor(.textTertiary)
            }
            
            Text(review.text)
                .trueFitTextStyle(.body)
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
                .padding(.vertical, Spacing.xs)
            
            HStack {
                Spacer()
                
                Button(action: {}) {
                    HStack(spacing: Spacing.xxs) {
                        Image(systemName: "hand.thumbsup")
                            .font(.system(size: 12))
                        Text("Helpful (\(review.isHelpful))")
                            .trueFitTextStyle(.caption)
                    }
                    .foregroundColor(.textSecondary)
                    .padding(.horizontal, Spacing.sm)
                    .padding(.vertical, Spacing.xxs)
                    .background(Color.trueFitBackground)
                    .clipShape(Capsule())
                }
            }
        }
        .padding(Spacing.md)
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.md))
        .trueFitShadow(.xs)
    }
}
