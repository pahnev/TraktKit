//
//  RecommendedMovie.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 11/10/2022.
//  Copyright © 2022 Pahnev. All rights reserved.
//

import Foundation

public struct RecommendedMovie: CodableEquatable {
    public let userCount: Int
    public let movie: Movie
}
