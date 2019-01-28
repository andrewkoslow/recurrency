//
//  ConversionService.swift
//  Recurrency
//
//  Created by Andrew Koslow on 29/01/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import Foundation

struct ConversionResponse {
    
    let conversion: Conversion?
    let error: Error?
    
}

protocol ConversionServiceProtocol {
    
    func fetchConversion(completion: @escaping (ConversionResponse) -> Void)
    
}
