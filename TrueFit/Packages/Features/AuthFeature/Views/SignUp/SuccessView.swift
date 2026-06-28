//
//  SuccessView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 27/06/2026.
//

import SwiftUI

struct SuccessView: View {
    var body: some View {
        VStack(spacing: Spacing.xl) {
            
            HStack {
                Spacer()
                Capsule()
                    .fill(Color.disabledColor)
                    .frame(width: 40, height: 5)
                    .padding(.top, Spacing.md)
                Spacer()
            }
            
            VStack(spacing: Spacing.lg) {
                ZStack {
                    Circle()
                        .fill(Color.semanticSuccess.opacity(0.15))
                        .frame(width: 120, height: 120)
                    Circle()
                        .fill(Color.semanticSuccess)
                        .frame(width: 80, height: 80)
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 32, weight: .bold))
                }
                .padding(.top, Spacing.lg)
                
                VStack(spacing: Spacing.xs) {
                    Text("Register Success")
                        .trueFitTextStyle(.title2)
                        .foregroundColor(.textPrimary)
                    
                    Text("Congratulation! your account already created.\nPlease login to get amazing experience.")
                        .trueFitTextStyle(.body)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.xxxxl)
                }
            }
            
            Spacer()
            
            PrimaryButton(title: "Go to Homepage") {
                // Route to Home
            }
            .padding(.horizontal, Spacing.md)
            .padding(.bottom, Spacing.xxl)
        }
        .background(Color.surface.ignoresSafeArea())
    }
}

#Preview {
    Color.trueFitBackground
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            SuccessView()
                .presentationDetents([.height(400)])
                .presentationDragIndicator(.hidden)
        }
}
