//
//  ConversionViewControllerProtocol.swift
//  Recurrency
//
//  Created by Andrew Koslow on 29/01/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import Foundation

struct ConversionViewModel {
    
    struct Amount {
        let currency: Currency
        let amount: Decimal?
    }
    
    let amounts: [Amount]
    
}

protocol ConversionViewControllerDelegate: AnyObject {
    
    func conversionViewController(_: ConversionViewControllerProtocol, didChangeAmount: ConversionViewModel.Amount)
    
}

protocol ConversionViewControllerProtocol: AnyObject {
    
    func update(with model: ConversionViewModel)
    
}
