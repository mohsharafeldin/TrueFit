//
//  SuccessView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 27/06/2026.
//

import SwiftUI

struct SuccessView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                Spacer()
                Capsule()
                    .fill(Color(.systemGray4))
                    .frame(width: 40, height: 5)
                    .padding(.top, 15)
                Spacer()
            }
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.2))
                        .frame(width: 120, height: 120)
                    Circle()
                        .fill(Color.green)
                        .frame(width: 80, height: 80)
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                }
                .padding(.top, 20)
                
                Text("Register Success")
                    .font(.title2)
                    .bold()
                
                Text("Congratulation! your account already created.\nPlease login to get amazing experience.")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            PrimaryButton(title: "Go to Homepage") {
                // Route to Home
            }
            .padding(.bottom, 30)
        }
        .background(Color.white)
    }
}

#Preview {
    Color.gray.opacity(0.3)
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            SuccessView()
                .presentationDetents([.height(400)])
                .presentationDragIndicator(.hidden)
        }
}
