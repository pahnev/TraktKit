//
//  Movie.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct Movie: CodableEquatable {
    // Extended: Min
    public let title: String
    public let year: Int?
    public let ids: ID

    // Extended: Full
    public let tagline: String?
    public let overview: String?
    // TODO: format "2008-07-18"
    public let released: String?
    public let runtime: Int?
    public let trailer: URL?
    public let homepage: URL?
    public let rating: Double?
    public let votes: Int?
    public let updatedAt: Date?
    public let language: String?
    public let availableTranslations: [String]?
    public let genres: [String]?
    public let certification: String?
}
