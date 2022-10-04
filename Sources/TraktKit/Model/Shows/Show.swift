//
//  Show.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct Airs: CodableEquatable {
    public let day: String?
    public let time: String?
    public let timezone: String?
}

public struct Show: CodableEquatable {
    // Extended: Min
    public let title: String
    public let year: Int?
    public let ids: ID

    // Extended: Full
    public let overview: String?
    public let firstAired: Date?
    public let airs: Airs?
    public let runtime: Int?
    public let certification: String?
    public let network: String?
    public let country: String?
    public let trailer: URL?
    public let homepage: URL?
    public let status: String?
    public let rating: Double?
    public let votes: Int?
    public let updatedAt: Date?
    public let language: String?
    public let availableTranslations: [String]?
    public let genres: [String]?
    public let airedEpisodes: Int?
}
