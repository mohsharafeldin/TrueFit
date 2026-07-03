//
//  GoogleSignInService.swift
//  TrueFit
//
//  Created by AndrewMagdy on 30/06/2026.
//

import UIKit
import GoogleSignIn
import FirebaseCore

final class GoogleSignInService: GoogleSignInServiceProtocol {
    func signIn() async throws -> GoogleSignInResult {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthError.missingClientID
        }

        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)

        let rootVC = await MainActor.run {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?.windows.first?.rootViewController
        }

        guard let rootVC else {
            throw AuthError.missingRootViewController
        }

        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)

        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthError.missingIDToken
        }

        return GoogleSignInResult(
            idToken: idToken,
            accessToken: result.user.accessToken.tokenString
        )
    }
}


enum AuthError: LocalizedError {
    case missingClientID
    case missingRootViewController
    case missingIDToken
    case invalidCredentials
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .missingClientID:
            return "Google Client ID not found"
        case .missingRootViewController:
            return "Unable to present sign-in screen"
        case .missingIDToken:
            return "Failed to retrieve ID token from Google"
        case .invalidCredentials:
            return "Invalid email or password"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
