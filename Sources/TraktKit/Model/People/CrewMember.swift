//
//  CrewMember.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct CrewMember: CodableEquatable {
    public let job: String
    public let person: Person?
    public let movie: Movie?
    public let show: Show?
}
