//
//  CurrencyTests.swift
//  RecurrencyTests
//
//  Created by Andrew Koslow on 03/02/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import XCTest
@testable import Recurrency

class CurrencyTests: XCTestCase {
    
    func testEmptyCodeThrows() {
        XCTAssertThrowsError(try Currency(code: ""))
    }
    
    func testCodeEquals() {
        let code = "ABC"
        
        XCTAssertEqual(code, try Currency(code: code).code)
    }
    
}
