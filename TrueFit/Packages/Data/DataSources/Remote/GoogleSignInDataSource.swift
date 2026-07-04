//
//  GoogleSignInService.swift
//  TrueFit
//
//  Created by AndrewMagdy on 30/06/2026.
//

import UIKit
import GoogleSignIn
import FirebaseCore

final class GoogleSignInDataSource: GoogleSignInServiceProtocol {
    @MainActor
    func signIn() async throws -> GoogleSignInResult {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthError.missingClientID
        }

        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)

        guard let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first?.rootViewController else {
            throw AuthError.missingRootViewController
        }

        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)

        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthError.missingIDToken
        }

        guard let email = result.user.profile?.email else {
            throw AuthError.unknown("missing email")
        }

        let firstName = result.user.profile?.givenName ?? "Google"
        let lastName = result.user.profile?.familyName ?? "User"

        return GoogleSignInResult(
            idToken: idToken,
            accessToken: result.user.accessToken.tokenString,
            email: email,
            firstName: firstName,
            lastName: lastName
        )
    }
}
