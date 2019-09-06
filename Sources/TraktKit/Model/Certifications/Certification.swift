//
//  Certification.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct Certifications: CodableEquatable {
    struct Certification: CodableEquatable {
        let name: String
        let slug: String
        let description: String
    }

    let us: [Certification]
}
