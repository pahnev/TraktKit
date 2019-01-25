//
//  String+TraktKit.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 30/01/2019.
//

import Foundation

extension String {
    init(_ value: Int?) {
        guard let value = value else { self.init(""); return }
        self.init(value)
    }

    func withoutLinebreaks() -> String {
        return self.replacingOccurrences(of: "\n", with: "")
    }

}
