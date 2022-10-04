//
//  Pagination.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

/**
 Some methods are paginated. By default, 1 page of 10 items will be returned. You can send these values by adding `?page={page}&limit={limit}` to the URL.
 */
public struct Pagination {
    /// Number of page of results to be returned.
    public let page: Int
    /// Number of results to return per page.
    public let limit: Int

    public init(page: Int, limit: Int) {
        self.page = page
        self.limit = limit
    }
}
