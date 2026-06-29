//
//  RootView.swift
//  TrueFit
//
//  Created by Mona Zarea on 27/06/2026.
//

import SwiftUI
struct RootView: View {
    @StateObject var viewModel: RootViewModel
    
    var body: some View {
        Group{
            switch viewModel.currentState {
            case .splash:
                Text("Splash Screen")
            case .unauthenticated:
                AuthFlowView()
                            
            case .authenticated:
                MainAppView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.currentState)
       
    }
}


