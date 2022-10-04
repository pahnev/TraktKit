//
//  Update.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct Update: CodableEquatable {
    public let updatedAt: Date
    public let movie: Movie?
    public let show: Show?
}
