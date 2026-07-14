import SwiftUI

struct ReviewModel: Identifiable {
    let id = UUID()
    let author: String
    let date: String
    let rating: Int
    let text: String
    let isHelpful: Int
}

let staticReviews = [
    ReviewModel(author: "Sarah J.", date: "2 days ago", rating: 5, text: "Absolutely love this! The quality is amazing and it fits perfectly. Will definitely be buying more in other colors.", isHelpful: 24),
    ReviewModel(author: "Michael T.", date: "1 week ago", rating: 4, text: "Great product, really nice material. Giving it 4 stars only because shipping took a bit longer than expected.", isHelpful: 12),
    ReviewModel(author: "Emma W.", date: "2 weeks ago", rating: 5, text: "Exactly what I was looking for. The AI styling recommendation was spot on. Highly recommend!", isHelpful: 86),
    ReviewModel(author: "David L.", date: "1 month ago", rating: 5, text: "Super comfortable and stylish. I've gotten so many compliments already.", isHelpful: 5)
]

struct ReviewsView: View {
    @EnvironmentObject var appRouter: AppRouter
    
    var body: some View {
        ZStack {
            Color.trueFitBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        summarySection
                        
                        Divider()
                        
                        VStack(spacing: Spacing.lg) {
                            ForEach(staticReviews) { review in
                                ReviewCard(review: review)
                            }
                        }
                    }
                    .padding(Spacing.lg)
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
            
            Text("Reviews")
                .trueFitTextStyle(.title2)
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
    }
    
    private var summarySection: some View {
        HStack(spacing: Spacing.xl) {
            // Overall Rating
            VStack(spacing: Spacing.xs) {
                Text("4.8")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
                
                HStack(spacing: 2) {
                    ForEach(0..<5) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.statusRating)
                            .font(.system(size: 14))
                    }
                }
                
                Text("320 Reviews")
                    .trueFitTextStyle(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            // Rating Bars
            VStack(spacing: Spacing.xs) {
                RatingBar(stars: 5, progress: 0.8)
                RatingBar(stars: 4, progress: 0.15)
                RatingBar(stars: 3, progress: 0.03)
                RatingBar(stars: 2, progress: 0.01)
                RatingBar(stars: 1, progress: 0.01)
            }
        }
        .padding(Spacing.md)
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.lg))
        .trueFitShadow(.sm)
    }
}

struct RatingBar: View {
    let stars: Int
    let progress: CGFloat
    
    var body: some View {
        HStack(spacing: Spacing.sm) {
            Text("\(stars)")
                .trueFitTextStyle(.caption)
                .foregroundColor(.textPrimary)
                .frame(width: 10)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.borderColor)
                        .frame(height: 6)
                    
                    Capsule()
                        .fill(Color.statusRating)
                        .frame(width: geometry.size.width * progress, height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}

struct ReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewsView()
            .environmentObject(AppRouter())
    }
}
