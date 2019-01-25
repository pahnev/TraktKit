//  Person.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

// Actor/Actress/Crew member
public struct Person: CodableEquatable {
    // Extended: Min
    public let name: String
    public let ids: ID
    
    // Extended: Full
    public let biography: String?
    public let birthday: Date?
    public let death: Date?
    public let birthplace: String?
    public let homepage: URL?

}
