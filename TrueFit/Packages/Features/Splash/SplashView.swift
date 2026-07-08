//
//  SplashView.swift
//  TrueFit
//
//  Created by AndrewMagdy on 27/06/2026.
//

import SwiftUI

struct SplashView: View {
    var onSplashComplete: () -> Void
    @State private var isVisible = false
    var body: some View {
        ZStack {
            Color(red: 0.0, green: 51.0/255.0, blue: 173.0/255.0)
                .ignoresSafeArea()

            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .scaleEffect(isVisible ? 1.0 : 0.5)
                .opacity(isVisible ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                isVisible = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                onSplashComplete()
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(onSplashComplete: {})
    }
}
