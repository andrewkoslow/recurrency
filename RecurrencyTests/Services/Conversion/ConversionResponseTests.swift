//
//  ConversionResponseTests.swift
//  RecurrencyTests
//
//  Created by Andrew Koslow on 04/02/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import XCTest
@testable import Recurrency

class ConversionResponseTests: XCTestCase {
    
    let usd = try! Currency(code: "USD")
    let eur = try! Currency(code: "EUR")
    let gbp = try! Currency(code: "GBP")
    
    func testDecodeFromValidJSON() throws {
        let base = usd
        let rated = gbp
        let value: Decimal = 2
        let json: [String : Any] = ["base": base.code, "rates": [rated.code: value]]
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        let response = try JSONDecoder().decode(ConversionResponse.self, from: data)
        
        XCTAssertNotNil(response.conversion)
        XCTAssertNil(response.error)
        
        let conversion = response.conversion!
        
        XCTAssertEqual(Set(conversion.currencies), Set([base, rated]))
        
        var amount: Amount
        
        amount = Amount(currency: base, value: 1)
        XCTAssertEqual(conversion.convert(amount: amount, to: rated).value, (amount.value ?? 0) * value / 1)
        
        amount = Amount(currency: rated, value: 1)
        XCTAssertEqual(conversion.convert(amount: amount, to: base).value, (amount.value ?? 0) * 1 / value)
    }
    
    func testDecodeFromInvalidJSONThrows() throws {
        let json = "{}"
        let data = json.data(using: .utf8)!
        
        XCTAssertThrowsError(try JSONDecoder().decode(ConversionResponse.self, from: data))
    }
    
}
