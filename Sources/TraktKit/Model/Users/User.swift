//
//  User.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct User: CodableEquatable {

    public struct Image: CodableEquatable {
        public struct Avatar: CodableEquatable {
            public let full: String
        }
        public let avatar: Avatar
    }

    public struct Ids: CodableEquatable {
        public let slug: String
    }
    
    // Min
    public let username: String?
    public let `private`: Bool
    public let name: String?
    public let vip: Bool?
    public let vipEp: Bool?
    public let ids: Ids
    
    // Full
    public let joinedAt: Date?
    public let location: String?
    public let about: String?
    public let gender: String?
    public let age: Int?
    public let images: Image?
    
    // VIP
    public let vipOg: Bool?
    public let vipYears: Int?
}
