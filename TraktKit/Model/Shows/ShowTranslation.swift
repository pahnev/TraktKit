//
//  ShowTranslation.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct ShowTranslation: CodableEquatable {
    public let title: String
    public let overview: String
    public let language: String
}
