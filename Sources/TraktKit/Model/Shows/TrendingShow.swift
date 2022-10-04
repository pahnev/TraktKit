//
//  TrendingShow.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct TrendingShow: CodableEquatable {
    // Extended: Min
    public let watchers: Int
    public let show: Show
}
