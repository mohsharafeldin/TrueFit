//
//  GoogleSignInResult.swift
//  TrueFit
//
//  Created by AndrewMagdy on 30/06/2026.
//

import Foundation
public struct GoogleSignInResult {
    public let idToken: String
    public let accessToken: String
    public let email: String
    public let firstName: String
    public let lastName: String
    
    public init(idToken: String, accessToken: String, email: String, firstName: String, lastName: String) {
        self.idToken = idToken
        self.accessToken = accessToken
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
}
