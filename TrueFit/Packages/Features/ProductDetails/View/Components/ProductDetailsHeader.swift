import SwiftUI

import SwiftUI

struct ProductDetailsHeader: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isFavorite = false
    
    var body: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .trueFitTextStyle(.title3)
                    .foregroundColor(.textPrimary)
                    .padding(Spacing.sm)
                    .background(Color.surface)
                    .clipShape(Circle())
                    .trueFitShadow(.xs)
            }
            
            Spacer()
            
            Text("Detail Product")
                .trueFitTextStyle(.title2)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring()) {
                    isFavorite.toggle()
                }
            }) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .trueFitTextStyle(.title3)
                    .foregroundColor(isFavorite ? .red : .textPrimary)
                    .padding(Spacing.sm)
                    .background(Color.surface)
                    .clipShape(Circle())
                    .trueFitShadow(.xs)
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.bottom, Spacing.sm)
    }
}
