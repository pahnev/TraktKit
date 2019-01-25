//
//  FollowUserResult.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct FollowUserResult: CodableEquatable {
    let approvedAt: Date
    let user: User
}
