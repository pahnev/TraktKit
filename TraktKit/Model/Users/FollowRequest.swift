//
//  FollowRequest.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct FollowRequest: CodableEquatable {
    public let id: Int
    public let requestedAt: Date
    public let user: User
}

public struct FollowResult: CodableEquatable {
    public let followedAt: Date
    public let user: User
}
