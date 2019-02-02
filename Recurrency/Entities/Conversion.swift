//
//  Conversion.swift
//  Recurrency
//
//  Created by Andrew Koslow on 29/01/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import Foundation

struct Conversion {
    
    enum Error: Swift.Error {
        case ratesContainsBase
        case rateLessThanOrEqualsZero
    }
    
    private let rates: [Currency: Decimal]
    
    var currencies: [Currency] {
        return Array(rates.keys)
    }
    
    init(base: Currency, rates: [Currency: Decimal]) throws {
        guard rates.keys.contains(base) == false else { throw Error.ratesContainsBase }
        guard rates.values.contains(where: { $0 <= 0 }) == false else { throw Error.rateLessThanOrEqualsZero }
        
        var rates = rates
        rates[base] = 1
        
        self.rates = rates
    }
    
    func convert(amount: Amount, to target: Currency) -> Amount {
        var convertedAmount = Amount(currency: target, value: nil)
        
        guard let denominator = rates[amount.currency] else { return convertedAmount }
        guard let multiplicator = rates[target] else { return convertedAmount }
        guard let value = amount.value else { return convertedAmount }
        
        convertedAmount.value = multiplicator / denominator * value
        
        return convertedAmount
    }
    
}
