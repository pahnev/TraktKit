//
//  WatchedEpisodes.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct WatchedEpisodes: CodableEquatable {
    // Extended: Min
    public let number: Int
    public let plays: Int
    public let lastWatchedAt: Date?    
}
