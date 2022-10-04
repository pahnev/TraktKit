//
//  MostShow.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

/// Used for most played, watched, and collected shows
public struct MostShow: CodableEquatable {
    // Extended: Min
    public let watcherCount: Int
    public let playCount: Int
    public let collectedCount: Int
    public let collectorCount: Int
    public let show: Show
}
