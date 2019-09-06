//
//  TokenResponse.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 29/08/2018.
//

import Foundation

public struct TokenResponse: CodableEquatable {
    public let accessToken: String
    public let tokenType: String
    public let expiresIn: Int
    public let refreshToken: String
    public let createdAt: Int
}
