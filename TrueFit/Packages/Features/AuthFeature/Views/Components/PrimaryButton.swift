//
//  PrimaryButton.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 27/06/2026.
//

import SwiftUI

struct PrimaryButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.35, green: 0.3, blue: 0.8))
                .cornerRadius(25)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    PrimaryButton(title: "Sign In", action: {
        print("Button Tapped")
    })
}
