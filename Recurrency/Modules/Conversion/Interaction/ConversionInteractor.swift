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
    private var amount: Amount?
    
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
    
    func conversionPresentation(_: ConversionPresentationProtocol, didChangeAmountCurrency: Currency) {
        
    }
    
    func conversionPresentation(_: ConversionPresentationProtocol, didChangeAmountValue value: Decimal?) {
        amount?.value = value
        
        updatePresentation()
    }
    
}

extension ConversionInteractor {
    
    private func calculateAmounts() -> [Amount] {
        guard let conversion = conversion else { return [] }
        
        if let amount = amount {
            return conversion.currencies.map { conversion.convert(amount: amount, to: $0) }
        } else {
            return conversion.currencies.map { Amount(currency: $0, value: nil) }
        }
    }
    
    private func updatePresentation() {
        let amounts = calculateAmounts()
        let model = ConversionPresentationModel(amounts: amounts)
        
        presentation.update(with: model)
    }
    
}
