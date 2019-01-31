//
//  ConversionInteractor.swift
//  Recurrency
//
//  Created by Andrew Koslow on 29/01/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import Foundation

class ConversionInteractor {
    
    private let presentation: ConversionPresentationProtocol
    private let service: ConversionServiceProtocol
    
    private var started = false
    private var conversion: Conversion?
    private var currency: Currency?
    private var amount: Decimal?
    
    init(presentation: ConversionPresentationProtocol, service: ConversionServiceProtocol) {
        self.presentation = presentation
        self.service = service
    }
    
}

extension ConversionInteractor: ConversionInteractionProtocol {
    
    func start() {
        guard started == false else { return }
        
        started = true
        
        service.fetchConversion { [weak self] (response) in
            guard let conversion = response.conversion else { return }
            
            self?.conversion = conversion
            self?.updatePresentation()
        }
    }
    
}

extension ConversionInteractor: ConversionPresentationDelegate {
    
    func conversionPresentation(_: ConversionPresentationProtocol, didChangeAmount amount: Decimal?, forCurrency currency: Currency) {
        self.currency = currency
        self.amount = amount
        
        updatePresentation()
    }
    
}

extension ConversionInteractor {
    
    private func calculateAmounts() -> [Currency: Decimal] {
        guard let conversion = conversion else { return [:] }
        
        var amounts: [Currency: Decimal] = [:]
        
        if let source = currency, let amount = amount {
            for target in conversion.currencies {
                amounts[target] = conversion.convert(amount: amount, from: source, to: target)
            }
        } else {
            for target in conversion.currencies {
                amounts[target] = 0
            }
        }
        
        return amounts
    }
    
    private func updatePresentation() {
        let amounts = calculateAmounts()
        let model = ConversionPresentationModel(amounts: amounts)
        
        presentation.update(with: model)
    }
    
}
