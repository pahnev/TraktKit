//
//  CalendarShow.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct CalendarShow: CodableEquatable {
    let firstAired: Date
    let episode: Episode
    let show: Show    
}
