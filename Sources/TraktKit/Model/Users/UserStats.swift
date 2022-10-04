//
//  UserStats.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct UserStats: CodableEquatable {
    let movies: Movies
    let shows: Shows
    let seasons: Seasons
    let episodes: Episodes
    let network: Network
    let ratings: UserStatsRatingsDistribution

    public struct Movies: CodableEquatable {
        let plays: Int
        let watched: Int
        let minutes: Int
        let collected: Int
        let ratings: Int
        let comments: Int
    }

    public struct Shows: CodableEquatable {
        let watched: Int
        let collected: Int
        let ratings: Int
        let comments: Int
    }

    public struct Seasons: CodableEquatable {
        let ratings: Int
        let comments: Int
    }

    public struct Episodes: CodableEquatable {
        let plays: Int
        let watched: Int
        let minutes: Int
        let collected: Int
        let ratings: Int
        let comments: Int
    }

    public struct Network: CodableEquatable {
        let friends: Int
        let followers: Int
        let following: Int
    }

    public struct UserStatsRatingsDistribution: CodableEquatable {
        let total: Int
        let distribution: Distribution

        public struct Distribution: CodableEquatable {
            public let one: Int
            public let two: Int
            public let three: Int
            public let four: Int
            public let five: Int
            public let six: Int
            public let seven: Int
            public let eight: Int
            public let nine: Int
            public let ten: Int

            enum CodingKeys: String, CodingKey {
                case one = "1"
                case two = "2"
                case three = "3"
                case four = "4"
                case five = "5"
                case six = "6"
                case seven = "7"
                case eight = "8"
                case nine = "9"
                case ten = "10"
            }
        }
    }
}
