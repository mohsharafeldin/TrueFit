//
//  SplashView.swift
//  TrueFit
//
//  Created by AndrewMagdy on 27/06/2026.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack{
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 250,height: 250)
            
        }.padding()
    }
}

#Preview {
    SplashView()
}
