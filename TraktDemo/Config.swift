//
//  Config.swift
//  TraktDemo
//
//  Created by Kirill Pahnev on 25/01/2019.
//

import Foundation

let placeHolderValue = "123"
struct Config {
    static let clientId = placeHolderValue
    static let secret = placeHolderValue
    #warning ("Remember to the URL type in the project settings as well")
    static let redirectURI = "yourapp://oauth"
}
