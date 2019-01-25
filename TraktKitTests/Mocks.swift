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
        return Config.secret
    }

    var clientId: String {
        return Config.clientId
    }
}

struct MockAuth: Authenticator {
    var accessToken: String = "123"
}
