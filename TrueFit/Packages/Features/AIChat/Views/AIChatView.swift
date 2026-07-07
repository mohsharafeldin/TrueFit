//
//  AIChatView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import SwiftUI

// MARK: - AI Chat View
struct AIChatView: View {
    @EnvironmentObject var appRouter: AppRouter
    @StateObject var viewModel: AIChatViewModel
    @FocusState private var isTextFieldFocused: Bool
    @State private var isGlowing = false
    
    init(viewModel: AIChatViewModel? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel ?? AIChatViewModel())
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Dynamic Background
            Color.trueFitBackground.ignoresSafeArea()
            
            // AI Glowing Aura Effect
            Circle()
                .fill(Color.brandPrimary.opacity(isGlowing ? 0.15 : 0.05))
                .blur(radius: 60)
                .frame(width: 300, height: 300)
                .offset(y: -200)
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: isGlowing)
                .onAppear { isGlowing = true }
            
            VStack(spacing: 0) {
                // Glassmorphism Header
                AIChatHeaderView()
                    .zIndex(1)
                
                // Chat Content
                if viewModel.messages.isEmpty {
                    AIChatWelcomeStateView(viewModel: viewModel)
                        .transition(.opacity)
                } else {
                    messagesListView
                        .transition(.opacity)
                }
            }
            .animation(TrueFitMotion.springDefault, value: viewModel.messages.count)
            .animation(TrueFitMotion.springDefault, value: viewModel.isTyping)
            
            // Floating Input Field
            AIChatInputView(viewModel: viewModel, isTextFieldFocused: $isTextFieldFocused)
                .padding(.bottom, Spacing.lg)
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .navigationBarHidden(true)
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
    
    // MARK: - Messages List
    private var messagesListView: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: Spacing.lg) {
                    ForEach(viewModel.messages) { message in
                        AIChatMessageView(message: message)
                            .id(message.id)
                            .transition(.asymmetric(
                                insertion: .move(edge: .bottom).combined(with: .opacity).combined(with: .scale(scale: 0.95)),
                                removal: .opacity
                            ))
                    }
                    
                    if viewModel.isTyping {
                        AITypingIndicatorView()
                            .id("TypingIndicator")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, Spacing.lg)
                            .transition(.opacity)
                    }
                    
                    Color.clear.frame(height: 100)
                }
                .padding(.vertical, Spacing.md)
            }
            .onChange(of: viewModel.messages.count) { _ in
                scrollToBottom(proxy: proxy)
            }
            .onChange(of: viewModel.isTyping) { _ in
                scrollToBottom(proxy: proxy)
            }
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        withAnimation(TrueFitMotion.springDefault) {
            if viewModel.isTyping {
                proxy.scrollTo("TypingIndicator", anchor: .bottom)
            } else if let last = viewModel.messages.last {
                proxy.scrollTo(last.id, anchor: .bottom)
            }
        }
    }
}

// MARK: - Previews
#if DEBUG
#Preview("Empty State") {
    AIChatView(viewModel: PreviewMocks.makeAIChatViewModel())
        .environmentObject(AppRouter())
}

#Preview("With Messages") {
    AIChatView(viewModel: PreviewMocks.makeAIChatViewModel(withMessages: true))
        .environmentObject(AppRouter())
}
#endif
