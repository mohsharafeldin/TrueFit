import SwiftUI

struct CartLoadingView: View {
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: Spacing.md) {
                    HStack {
                        Text("My Cart")
                            .trueFitTextStyle(.largeTitle)
                            .foregroundColor(.textPrimary)
                        Spacer()
                    }
                    .padding(.horizontal, Spacing.md)
                    .padding(.top, Spacing.lg)
                    
                    ForEach(0..<3, id: \.self) { _ in
                        CartLineLoadingRow()
                    }
                }
                .padding(.bottom, Spacing.xxl)
            }
            
            // Placeholder summary section
            VStack(spacing: Spacing.md) {
                HStack {
                    Text("Subtotal")
                        .trueFitTextStyle(.body)
                    Spacer()
                    Text("$0.00")
                }
                HStack {
                    Text("Total")
                        .trueFitTextStyle(.title3)
                    Spacer()
                    Text("$0.00")
                }
            }
            .padding(Spacing.lg)
            .background(Color.surface)
            .clipShape(RoundedRectangle.trueFit(Radius.lg))
            .shadow(color: Color.shadowColor.opacity(0.05), radius: 8, x: 0, y: 2)
            .padding(Spacing.md)
        }
        .redacted(reason: .placeholder)
    }
}
