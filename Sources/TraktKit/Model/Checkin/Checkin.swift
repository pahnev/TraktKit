//
//  Checkin.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct ShareSettings: CodableEquatable {
    public let facebook: Bool
    public let twitter: Bool
    public let tumblr: Bool
}

public struct Checkin: CodableEquatable {
    /// Trakt History ID
    public let id: Int
    public let watchedAt: Date
    public let sharing: ShareSettings

    public let movie: Movie?
    public let show: Show?
    public let episode: Episode?
}
