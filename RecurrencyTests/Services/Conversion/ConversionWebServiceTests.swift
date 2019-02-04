//
//  ConversionWebServiceTests.swift
//  RecurrencyTests
//
//  Created by Andrew Koslow on 04/02/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import XCTest
@testable import Recurrency

class ConversionWebServiceTests: XCTestCase {
    
    let usd = try! Currency(code: "USD")
    let eur = try! Currency(code: "EUR")
    
    func testValidDataResponse() throws {
        let base = usd
        let rated = eur
        let url = URL(json: ["base": base.code, "rates": [rated.code: 1]])!
        let configuration = ConversionWebService.Configuration(conversionURL: url)
        let service = ConversionWebService(configuration: configuration, session: URLSession.shared)
        
        let testExpectation = expectation(description: "service responded")
        
        service.fetchConversion { (response) in
            XCTAssertNotNil(response.conversion)
            XCTAssertNil(response.error)
            XCTAssertTrue(Thread.isMainThread)
            
            testExpectation.fulfill()
        }
        
        wait(for: [testExpectation], timeout: 1.0)
    }
    
    func testInvalidDataResponse() throws {
        let url = URL(json: ["base": "", "rates": []])!
        let configuration = ConversionWebService.Configuration(conversionURL: url)
        let service = ConversionWebService(configuration: configuration, session: URLSession.shared)
        
        let testExpectation = expectation(description: "service responded")
        
        service.fetchConversion { (response) in
            XCTAssertNil(response.conversion)
            XCTAssertNotNil(response.error)
            XCTAssertTrue(Thread.isMainThread)
            
            testExpectation.fulfill()
        }
        
        wait(for: [testExpectation], timeout: 1.0)
    }
    
}
