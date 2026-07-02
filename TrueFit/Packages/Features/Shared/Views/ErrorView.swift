import SwiftUI

struct ErrorView: View {
    let message: String
    let showRetry: Bool
    let onRetry: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.red)
            
            Text("Oops!")
                .font(.headline)
            
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            if showRetry {
                Button(action: {
                    onRetry?()
                }) {
                    Text("Retry")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 8)
            }
        }
        .padding()
    }
}

#Preview {
    ErrorView(
        message: "Please check your internet connection and try again.",
        showRetry: true,
        onRetry: {}
    )
}
