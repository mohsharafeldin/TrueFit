import SwiftUI

struct CartLineLoadingRow: View {
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            RoundedRectangle(cornerRadius: Radius.md)
                .fill(Color.borderColor)
                .frame(width: 90, height: 90)
            
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Placeholder title goes here")
                    .trueFitTextStyle(.headline)
                Text("$0.00")
                    .trueFitTextStyle(.body)
            }
            Spacer()
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.xs)
    }
}
