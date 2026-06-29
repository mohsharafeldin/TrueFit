//
//  File.swift
//  TrueFit
//
//  Created by Mona Zarea on 27/06/2026.
//

import SwiftUI
enum Route : Hashable{
    case signIn
    case signUp
    case home
    case cart
    case checkout
    case profile
    
    
}

final class AppRouter : ObservableObject {
    @Published  var path = NavigationPath()
    
    func navigate(to router : Route){
        path.append(router)
    }
    func goBack(){
        if !path.isEmpty{
            path.removeLast()
        }
    }
    
    func popToRoot(){
        path.removeLast(path.count)
    }
}
