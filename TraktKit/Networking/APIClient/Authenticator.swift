//
//  Authenticator.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 03/09/2018.
//

import Foundation

public protocol Authenticator {
    var accessToken: String { get }
}
