//
//  ConversionPollingServiceTests.swift
//  RecurrencyTests
//
//  Created by Andrew Koslow on 04/02/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import XCTest
@testable import Recurrency

class ConversionPollingServiceTests: XCTestCase {
    
    let usd = try! Currency(code: "USD")
    let eur = try! Currency(code: "EUR")
    
    func testSuccessResponse() throws {
        let interval = 1
        let dataService = ConversionServiceMock()
        let configuration = ConversionPollingService.Configuration(pollingInterval: interval)
        let service = ConversionPollingService(configuration: configuration, service: dataService)
        
        let base = usd
        let rated = eur
        let conversion = try Conversion(base: base, rates: [rated: 1])
        
        dataService.conversion = conversion
        dataService.error = nil
        
        let testExpectation = expectation(description: "service responded")
        
        service.fetchConversion { (response) in
            XCTAssertNotNil(response.conversion)
            XCTAssertNil(response.error)
            XCTAssertTrue(Thread.isMainThread)
            
            testExpectation.fulfill()
        }
        
        wait(for: [testExpectation], timeout: TimeInterval(interval) * 1.5)
    }
    
    
    func testFailureResponse() throws {
        let interval = 1
        let dataService = ConversionServiceMock()
        let configuration = ConversionPollingService.Configuration(pollingInterval: interval)
        let service = ConversionPollingService(configuration: configuration, service: dataService)
        
        dataService.conversion = nil
        dataService.error = GenericError()
        
        let testExpectation = expectation(description: "service responded")
        
        service.fetchConversion { (response) in
            XCTAssertNil(response.conversion)
            XCTAssertNotNil(response.error)
            XCTAssertTrue(Thread.isMainThread)
            
            testExpectation.fulfill()
        }
        
        wait(for: [testExpectation], timeout: TimeInterval(interval) * 1.5)
    }
    
}
