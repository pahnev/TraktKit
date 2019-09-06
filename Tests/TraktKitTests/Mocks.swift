//
//  Mocks.swift
//  TraktKitTests
//
//  Created by Kirill Pahnev on 29/01/2019.
//

import Foundation
import TraktKit

struct MockClient: ClientProvider {
    var secret: String? {
        return "made up secret"
    }

    var clientId: String {
        return "made up client id"
    }
}

struct MockAuth: Authenticator {
    var accessToken: String = "123"
}
