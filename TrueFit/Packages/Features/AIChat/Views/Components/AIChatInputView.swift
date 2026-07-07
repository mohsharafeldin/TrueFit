//
//  AIChatInputView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import SwiftUI

struct AIChatInputView: View {
    @ObservedObject var viewModel: AIChatViewModel
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        HStack(spacing: Spacing.sm) {
            TextField("Message TrueFit AI...", text: $viewModel.inputText)
                .trueFitTextStyle(.body)
                .padding(.horizontal, Spacing.sm)
                .focused($isTextFieldFocused)
                .onSubmit {
                    viewModel.sendMessage(viewModel.inputText)
                }
            
            Button(action: {
                viewModel.sendMessage(viewModel.inputText)
            }) {
                ZStack {
                    Circle()
                        .fill(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.surface : Color.brandPrimary)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "arrow.up")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .textTertiary : .white)
                }
            }
            .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .animation(TrueFitMotion.springSnappy, value: viewModel.inputText)
        }
        .padding(6)
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.pill))
        .trueFitShadow(.md)
        .padding(.horizontal, Spacing.lg)
    }
}

#if DEBUG
#Preview {
    AIChatInputView(viewModel: AIChatViewModel())
        .padding()
        .background(Color.trueFitBackground)
}
#endif

