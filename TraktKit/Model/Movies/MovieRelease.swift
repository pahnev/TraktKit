//
//  MovieRelease.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct MovieRelease: CodableEquatable {
    let country: String
    let certification: String
    // TODO
    let releaseDate: String
    let releaseType: ReleaseType
    let note: String?
        
    public enum ReleaseType: String, CodableEquatable {
        case unknown
        case premiere
        case limited
        case theatrical
        case digital
        case physical
        case tv
    }
}
