//
//  ConversionServiceMock.swift
//  RecurrencyTests
//
//  Created by Andrew Koslow on 04/02/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import Foundation
@testable import Recurrency

class ConversionServiceMock: ConversionServiceProtocol {
    
    var conversion: Conversion?
    var error: Error?
    
    func fetchConversion(completion: @escaping (ConversionResponse) -> Void) {
        let response = ConversionResponse(conversion: conversion, error: error)
        
        completion(response)
    }
    
}
