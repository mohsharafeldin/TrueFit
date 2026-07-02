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
        VStack{
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 250,height: 250)
            
        }.padding()
            .onAppear {
                withAnimation(.easeIn(duration: 0.5)) {
                    isVisible = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
