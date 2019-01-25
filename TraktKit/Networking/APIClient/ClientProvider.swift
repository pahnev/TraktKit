//
//  ClientProvider.swift
//  TMDBKit
//
//  Created by Kirill Pahnev on 30/06/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public protocol ClientProvider {
    /// The Client ID for you Trakt app.
    var clientId: String { get }

    /// The Client secret for your Trakt app.
    var secret: String? { get }
}
