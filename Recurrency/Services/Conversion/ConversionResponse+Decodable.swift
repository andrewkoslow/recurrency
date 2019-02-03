//
//  ConversionResponse+Decodable.swift
//  Recurrency
//
//  Created by Andrew Koslow on 03/02/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import Foundation

extension ConversionResponse: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case base
        case rates
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        
        let baseCurrencyCode = try map.decode(String.self, forKey: .base)
        let base = try Currency(code: baseCurrencyCode)
        
        let ratesRaw = try map.decode([String: Decimal].self, forKey: .rates).map({ (try Currency(code: $0.key), $0.value) })
        let rates = Dictionary(ratesRaw, uniquingKeysWith: { _, latest in latest })
        
        conversion = try Conversion(base: base, rates: rates)
        error = nil
    }
    
}
