//
//  XCTestCase+Await.swift
//  
//
//  Created by Pahnev, Kirill on 5.10.2022.
//

import XCTest

extension XCTestCase {
    func awaitFor<T>(_ function: (@escaping (T) -> Void) -> Void) throws -> T {
        let expectation = self.expectation(description: "Async call")
        var result: T?

        function { value in
            result = value
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10)

        guard let unwrappedResult = result else {
            fatalError()
        }

        return unwrappedResult
    }
}
