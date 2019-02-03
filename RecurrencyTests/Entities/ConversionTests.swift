//
//  ConversionTests.swift
//  RecurrencyTests
//
//  Created by Andrew Koslow on 03/02/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import XCTest
@testable import Recurrency

class ConversionTests: XCTestCase {
    
    let usd = try! Currency(code: "USD")
    let eur = try! Currency(code: "EUR")
    let gbp = try! Currency(code: "GBP")
    
    func testRatesWithBaseThrows() {
        let base = usd
        let rates: [Currency: Decimal] = [base: 1, eur: 2]
        
        XCTAssertThrowsError(try Conversion(base: base, rates: rates))
    }
    
    func testZeroRateThrows() {
        let base = usd
        let rates: [Currency: Decimal] = [eur: 0]
        
        XCTAssertThrowsError(try Conversion(base: base, rates: rates))
    }
    
    func testNegativeRateThrows() {
        let base = usd
        let rates: [Currency: Decimal] = [eur: -1]
        
        XCTAssertThrowsError(try Conversion(base: base, rates: rates))
    }
    
    func testCurrenciesContainsBase() throws {
        let base = usd
        let rates: [Currency: Decimal] = [eur: 1]
        let conversion = try Conversion(base: base, rates: rates)
        
        XCTAssertTrue(conversion.currencies.contains(base))
    }
    
    func testCurrenciesContainsRates() throws {
        let base = usd
        let rates: [Currency: Decimal] = [eur: 1, gbp: 1]
        let currencies = Array(rates.keys) + [base]
        let conversion = try Conversion(base: base, rates: rates)
        
        XCTAssertEqual(Set(currencies), Set(conversion.currencies))
    }
    
    func testCurrenciesContainsBaseOnly() throws {
        let base = usd
        let conversion = try Conversion(base: base, rates: [:])
        
        XCTAssertEqual([base], conversion.currencies)
    }
    
    func testConvertedCurrencyFromBase() throws {
        let base = usd
        let rated = eur
        let unknown = gbp
        let conversion = try Conversion(base: base, rates: [rated: 1])
        let source = Amount(currency: base, value: 1)
        
        XCTAssertEqual(conversion.convert(amount: source, to: base).currency, base)
        XCTAssertEqual(conversion.convert(amount: source, to: rated).currency, rated)
        XCTAssertEqual(conversion.convert(amount: source, to: unknown).currency, unknown)
    }
    
    func testConvertedCurrencyFromRated() throws {
        let base = usd
        let rated = eur
        let unknown = gbp
        let conversion = try Conversion(base: base, rates: [rated: 1])
        let source = Amount(currency: rated, value: 1)
        
        XCTAssertEqual(conversion.convert(amount: source, to: base).currency, base)
        XCTAssertEqual(conversion.convert(amount: source, to: rated).currency, rated)
        XCTAssertEqual(conversion.convert(amount: source, to: unknown).currency, unknown)
    }
    
    func testConvertedCurrencyFromUnknown() throws {
        let base = usd
        let rated = eur
        let unknown = gbp
        let conversion = try Conversion(base: base, rates: [rated: 1])
        let source = Amount(currency: unknown, value: 1)
        
        XCTAssertEqual(conversion.convert(amount: source, to: base).currency, base)
        XCTAssertEqual(conversion.convert(amount: source, to: rated).currency, rated)
        XCTAssertEqual(conversion.convert(amount: source, to: unknown).currency, unknown)
    }
    
    func testConvertedZeroValue() throws {
        let conversion = try Conversion(base: usd, rates: [eur: 10])
        var source: Amount
        
        source = Amount(currency: usd, value: 0)
        XCTAssertEqual(conversion.convert(amount: source, to: eur).value, 0)
        
        source = Amount(currency: eur, value: 0)
        XCTAssertEqual(conversion.convert(amount: source, to: usd).value, 0)
    }
    
    func testConvertedPositiveValue() throws {
        let conversion = try Conversion(base: usd, rates: [eur: 10])
        var source: Amount
        
        source = Amount(currency: usd, value: 1)
        XCTAssertEqual(conversion.convert(amount: source, to: eur).value, 10)
        
        source = Amount(currency: eur, value: 1)
        XCTAssertEqual(conversion.convert(amount: source, to: usd).value, 0.1)
    }
    
    func testConvertedNegativeValue() throws {
        let conversion = try Conversion(base: usd, rates: [eur: 10])
        var source: Amount
        
        source = Amount(currency: usd, value: -1)
        XCTAssertEqual(conversion.convert(amount: source, to: eur).value, -10)
        
        source = Amount(currency: eur, value: -1)
        XCTAssertEqual(conversion.convert(amount: source, to: usd).value, -0.1)
    }
    
    func testConvertedNilValue() throws {
        let conversion = try Conversion(base: usd, rates: [eur: 10])
        var source: Amount
        
        source = Amount(currency: usd, value: nil)
        XCTAssertEqual(conversion.convert(amount: source, to: eur).value, nil)
        
        source = Amount(currency: eur, value: nil)
        XCTAssertEqual(conversion.convert(amount: source, to: usd).value, nil)
    }
    
}
