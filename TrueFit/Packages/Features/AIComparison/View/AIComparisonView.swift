import SwiftUI

struct AIComparisonView: View {
    @StateObject var viewModel: AIComparisonViewModel
    @State private var inputText: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Selected Products Header
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.md) {
                    ForEach(viewModel.products) { product in
                        HStack(spacing: Spacing.sm) {
                            AsyncImage(url: product.imageURL) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .clipShape(RoundedRectangle(cornerRadius: Radius.sm))
                                } else {
                                    Color.surface
                                        .frame(width: 40, height: 40)
                                        .clipShape(RoundedRectangle(cornerRadius: Radius.sm))
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text(product.title)
                                    .font(.system(size: 12, weight: .semibold))
                                    .lineLimit(1)
                                Text(product.price)
                                    .font(.system(size: 10))
                                    .foregroundColor(.textSecondary)
                            }
                            .frame(width: 100, alignment: .leading)
                        }
                        .padding(Spacing.sm)
                        .background(Color.surface)
                        .clipShape(RoundedRectangle(cornerRadius: Radius.md))
                    }
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.vertical, Spacing.sm)
            }
            .background(Color.trueFitBackground)
            
            Divider()
            
            // Chat Area
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: Spacing.lg) {
                        if viewModel.hasStructuredResult, let result = viewModel.comparisonResult {
                            RichComparisonView(result: result)
                                .padding(.top, Spacing.md)
                        }
                        
                        // Skip the first message which is the hidden system prompt
                        ForEach(viewModel.messages.dropFirst()) { message in
                            ChatBubble(message: message)
                                .id(message.id)
                        }
                        
                        if viewModel.isLoading {
                            HStack {
                                ProgressView()
                                    .padding()
                                    .background(Color.surface)
                                    .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
                                Spacer()
                            }
                            .padding(.horizontal, Spacing.lg)
                            .id("LoadingIndicator")
                        }
                        
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.semanticDanger)
                                .font(.caption)
                                .padding()
                                .id("ErrorMessage")
                        }
                    }
                    .padding(.vertical, Spacing.lg)
                }
                .onChange(of: viewModel.messages) { _ in
                    if let lastId = viewModel.messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color.trueFitBackground)
            
            // Input Area
            HStack(spacing: Spacing.sm) {
                TextField("Ask about these products...", text: $inputText)
                    .padding(Spacing.md)
                    .background(Color.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                
                Button(action: {
                    viewModel.sendMessage(inputText)
                    inputText = ""
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(inputText.isEmpty ? .textTertiary : .brandPrimary)
                }
                .disabled(inputText.isEmpty || viewModel.isLoading)
            }
            .padding(Spacing.lg)
            .background(Color.trueFitBackground)
        }
        .navigationTitle("AI Comparison")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
            }
            
            if message.role == .model,
               let data = message.text.data(using: .utf8),
               let followUp = try? JSONDecoder().decode(AIFollowUpResult.self, from: data) {
                FollowUpCard(result: followUp)
                    .padding(.horizontal, Spacing.lg)
            } else {
                // Using native Markdown support in Text
                Text((try? AttributedString(markdown: message.text)) ?? AttributedString(message.text))
                    .padding(Spacing.md)
                    .foregroundColor(message.role == .user ? .white : .textPrimary)
                    .background(message.role == .user ? Color.brandPrimary : Color.surface)
                    .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
                    .padding(.horizontal, Spacing.lg)
            }
            
            if message.role == .model {
                Spacer()
            }
        }
    }
}

struct FollowUpCard: View {
    let result: AIFollowUpResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.brandPrimary)
                Text(result.title)
                    .trueFitTextStyle(.headline)
                    .foregroundColor(.textPrimary)
            }
            
            Text(result.explanation)
                .trueFitTextStyle(.subheadline)
                .foregroundColor(.textSecondary)
            
            if !result.keyPoints.isEmpty {
                Divider()
                
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    ForEach(result.keyPoints, id: \.self) { point in
                        HStack(alignment: .top, spacing: Spacing.sm) {
                            Circle()
                                .fill(Color.brandPrimary)
                                .frame(width: 6, height: 6)
                                .padding(.top, 6)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(point.pointTitle)
                                    .trueFitTextStyle(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.textPrimary)
                                Text(point.pointDescription)
                                    .trueFitTextStyle(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                    }
                }
            }
        }
        .padding(Spacing.md)
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .trueFitShadow(.sm)
    }
}

struct RichComparisonView: View {
    let result: AIComparisonResult
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            // Overall Summary
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("AI Summary")
                    .trueFitTextStyle(.headline)
                    .foregroundColor(.brandPrimary)
                
                Text(result.overallSummary)
                    .trueFitTextStyle(.body)
                    .foregroundColor(.textPrimary)
            }
            .padding()
            .background(Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
            .trueFitShadow(.sm)
            .padding(.horizontal, Spacing.lg)
            
            // Product Cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.lg) {
                    ForEach(result.analyses, id: \.productId) { analysis in
                        ProductAnalysisCard(analysis: analysis)
                            .frame(width: 280)
                    }
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, Spacing.md)
            }
        }
    }
}

struct ProductAnalysisCard: View {
    let analysis: AIComparisonResult.ProductAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text(analysis.title)
                .trueFitTextStyle(.title3)
                .foregroundColor(.textPrimary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(analysis.summary)
                .trueFitTextStyle(.subheadline)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            
            Divider()
            
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Pros")
                    .font(.caption.bold())
                    .foregroundColor(.semanticSuccess)
                
                ForEach(analysis.pros, id: \.self) { pro in
                    HStack(alignment: .top) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.semanticSuccess)
                            .font(.system(size: 14))
                        Text(pro)
                            .trueFitTextStyle(.caption)
                            .foregroundColor(.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Cons")
                    .font(.caption.bold())
                    .foregroundColor(.semanticDanger)
                
                ForEach(analysis.cons, id: \.self) { con in
                    HStack(alignment: .top) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.semanticDanger)
                            .font(.system(size: 14))
                        Text(con)
                            .trueFitTextStyle(.caption)
                            .foregroundColor(.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Best For")
                    .font(.caption.bold())
                    .foregroundColor(.brandPrimary)
                
                Text(analysis.bestFor)
                    .trueFitTextStyle(.caption)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .trueFitShadow(.sm)
    }
}
