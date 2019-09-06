//
//  Likes.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct Like: CodableEquatable {
    public let likedAt: Date
    public let type: LikeType
    public let list: List?
    public let comment: Comment?
    
    public enum LikeType: String, CodableEquatable {
        case comment
        case list
    }
}
