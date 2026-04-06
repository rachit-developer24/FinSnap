//
//  AuthenticationServiceProtocol.swift
//  finSnap
//
//  Created by Rachit Sharma on 06/04/2026.
//

import Foundation
protocol AuthenticationServiceProtocol{
    func authenticate()async throws ->Bool
}
