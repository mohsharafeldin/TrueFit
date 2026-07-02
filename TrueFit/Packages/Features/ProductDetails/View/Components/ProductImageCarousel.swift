import SwiftUI

struct ProductImageCarousel: View {
    let images: [ProductImage]
    @State private var currentIndex: Int = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentIndex) {
                if images.isEmpty {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.textTertiary)
                        .padding(Spacing.xxxxxl)
                        .tag(0)
                } else {
                    ForEach(Array(images.enumerated()), id: \.element.id) { index, image in
                        AsyncImage(url: image.src) { phase in
                            switch phase {
                            case .empty:
                                ProgressView().tint(.brandPrimary)
                            case .success(let img):
                                img.resizable()
                                    .scaledToFill()
                            case .failure:
                                Image(systemName: "photo")
                                    .foregroundColor(.textTertiary)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .tag(index)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            if images.count > 1 {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(currentIndex > 0 ? .textPrimary : .textTertiary.opacity(0.5))
                    
                    Text("\(currentIndex + 1) / \(images.count)")
                        .trueFitTextStyle(.caption)
                        .foregroundColor(.textPrimary)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(currentIndex < images.count - 1 ? .textPrimary : .textTertiary.opacity(0.5))
                }
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.xs)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle.trueFit(Radius.pill))
                .trueFitShadow(.xs)
                .padding(.bottom, 60)
            }
        }
    }
}

