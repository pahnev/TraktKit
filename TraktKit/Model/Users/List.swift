//
//  List.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public enum ListPrivacy: String, CodableEquatable {
    case `private`
    case friends
    case `public`
}

public struct List: CodableEquatable {
    public let allowComments: Bool
    public let commentCount: Int
    public let createdAt: Date?
    public let description: String?
    public let displayNumbers: Bool
    public var itemCount: Int
    public var likes: Int
    public let name: String
    public let privacy: ListPrivacy
    public let updatedAt: Date
    public let ids: ListId
}

public struct TrendingList: CodableEquatable {
    public let likeCount: Int
    public let commentCount: Int
    public let list: List
}
