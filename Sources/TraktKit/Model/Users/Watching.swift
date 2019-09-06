//
//  Watching.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct Watching: CodableEquatable {
    public let expiresAt: Date
    public let startedAt: Date
    public let action: String
    public let type: String
    
    public let episode: Episode?
    public let show: Show?
    public let movie: Movie?
}
