//
//  AccountSettings.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct AccountSettings: CodableEquatable {
    public let user: User
    public let connections: Connections

    public struct Connections: CodableEquatable {
        public let facebook: Bool
        public let twitter: Bool
        public let google: Bool
        public let tumblr: Bool
        public let medium: Bool
        public let slack: Bool
    }
}
