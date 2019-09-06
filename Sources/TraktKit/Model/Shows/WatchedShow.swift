//
//  WatchedShow.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct WatchedShow: CodableEquatable {
    
    // Extended: Min
    public let plays: Int // Total number of plays
    public let lastWatchedAt: Date?
    public let show: Show
    public let seasons: [WatchedSeason]    
}
