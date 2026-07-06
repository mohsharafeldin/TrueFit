//
//  GoogleAuthUseCase.swift
//  TrueFit
//
//  Created by AndrewMagdy on 03/07/2026.
//

import Foundation
protocol LoginWithGoogleUseCaseProtocol {
    func execute() async throws -> AuthResult
}
