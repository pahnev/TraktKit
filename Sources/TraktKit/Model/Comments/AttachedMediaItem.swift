//
//  TraktAttachedMediaItem.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct AttachedMediaItem: CodableEquatable {
    public let type: String
    public let movie: Movie?
    public let show: Show?
    public let season: Season?
    public let episode: Episode?
    public let list: List?
}
