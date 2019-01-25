//
//  DecodableInteger.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 31/08/2018.
//

import Foundation
/**
 Generic type for decodable integers, which we want to handle as separate types
 */
public struct DecodableInteger<T>: CodableEquatable, CustomStringConvertible, ExpressibleByIntegerLiteral, Hashable {
    public var hashValue: Int

    private let value: Int

    public init(integerLiteral value: Int) {
        self.init(value)
    }

    public init(_ value: Int) {
        self.value = value
        self.hashValue = value.hashValue
    }

    public var description: String {
        return String(value)
    }

    public var integerValue: Int {
        return value
    }

}

extension DecodableInteger {
    public init(from decoder: Decoder) throws {
        let root = try decoder.singleValueContainer()
        value = try root.decode(Int.self)
        hashValue = value.hashValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.value)
    }

}
