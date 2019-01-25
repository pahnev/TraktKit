//
//  TraktCommentLikedUser.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct CommentLikedUser: CodableEquatable {
    public let likedAt: Date
    public let user: User
}
