//
//  HistoryItem.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct HistoryItem: CodableEquatable {
    
    public let id: HistoryItemId
    public let watchedAt: Date
    public let action: String
    public let type: String
    
    public let movie: Movie?
    public let show: Show?
    public let season: Season?
    public let episode: Episode?
}
