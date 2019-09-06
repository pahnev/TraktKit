//
//  Comment.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct Comment: CodableEquatable {
    public let id: Int
    public let parentId: Int
    public let createdAt: Date
    public var comment: String
    public let spoiler: Bool
    public let review: Bool
    public let replies: Int
    public let likes: Int
    public let userRating: Int?
    public let user: User
    
}

public extension Sequence where Iterator.Element == Comment {
    func hideSpoilers() -> [Comment] {
        var copy: [Comment] = self as! [Comment]
        
        for (index, var comment) in copy.enumerated() {
            var text = comment.comment
            
            if let start = text.range(of: "[spoiler]"),
                let end = text.range(of: "[/spoiler]") {
                
                let range = Range(uncheckedBounds: (start.lowerBound, end.upperBound))
                // Clean up title
                text.removeSubrange(range)
                comment.comment = text.trimmingCharacters(in: .whitespaces)
                copy[index] = comment
            }
        }
        return copy.filter { $0.spoiler == false }
    }
}
