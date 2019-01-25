//
//  AnticipatedMovie.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct AnticipatedMovie: CodableEquatable {
    // Extended: Min
    public let listCount: Int
    public let movie: Movie    
}
