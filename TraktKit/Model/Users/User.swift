//
//  User.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct User: CodableEquatable {
    
    // Min
    public let username: String?
    public let `private`: Bool
    public let name: String?
    public let vip: Bool?
    public let vipEp: Bool?
    
    // Full
    public let joinedAt: Date?
    public let location: String?
    public let about: String?
    public let gender: String?
    public let age: Int?
    
    // VIP
    public let vipOg: Bool?
    public let vipYears: Int?
}
