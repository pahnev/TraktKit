//
//  PlaybackProgress.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct PlaybackProgress: CodableEquatable {
    public let progress: Float
    public let pausedAt: Date
    public let id: Int
    public let type: String
    public let movie: Movie?
    public let episode: Episode?
    public let show: Show?
}
