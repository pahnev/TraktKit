//
//  UpdatedMoviesResponse.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 06/08/2018.
//

import Foundation

public struct UpdatedMoviesResponse: CodableEquatable {
    public let updatedAt: Date
    public let movie: Movie
}
