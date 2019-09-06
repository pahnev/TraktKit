//
//  ExtendedType.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 03/09/2018.
//

import Foundation

public enum ExtendedType: String {
    /// Least amount of info
    case min
    /// All information, excluding images
    case full
    /// Collection only. Additional video and audio info.
    case metadata
    /// Get all seasons and episodes
    case episodes
    /// Get watched shows without seasons. https://trakt.docs.apiary.io/#reference/users/watched/get-watched
    case noSeasons = "noseasons"
}
