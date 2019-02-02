//
//  ConversionPresentationProtocol.swift
//  Recurrency
//
//  Created by Andrew Koslow on 23/01/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import Foundation

struct ConversionPresentationModel {
    
    let amounts: [Amount]
    
}

protocol ConversionPresentationDelegate: AnyObject {
    
    func conversionPresentation(_: ConversionPresentationProtocol, didChangeAmountCurrency: Currency)
    func conversionPresentation(_: ConversionPresentationProtocol, didChangeAmountValue: Decimal?)
    
}

protocol ConversionPresentationProtocol: AnyObject {
    
    func update(with model: ConversionPresentationModel)
    
}
