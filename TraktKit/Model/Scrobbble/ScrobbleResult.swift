//
//  ScrobbleResult.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct ScrobbleResult: CodableEquatable {
    let id: Int
    let action: String
    let progress: Float
    let movie: Movie?
    let episode: Episode?
    let show: Show?
}
