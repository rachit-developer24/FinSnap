//
//  AuthenticationService.swift
//  finSnap
//
//  Created by Rachit Sharma on 06/04/2026.
//

import Foundation
import LocalAuthentication

class AuthenticationService:AuthenticationServiceProtocol{
    func authenticate() async throws -> Bool {
       let context = LAContext()
       return try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock FinSnap")
      
    }
}
