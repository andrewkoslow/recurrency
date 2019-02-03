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
    private var base: Amount?
    
    init(presentation: ConversionPresentationProtocol, service: ConversionServiceProtocol) {
        self.presentation = presentation
        self.service = service
    }
    
}

extension ConversionInteractor {
    
    private struct Defaults {
        static let baseAmountValue: Decimal = 100
    }
    
}

extension ConversionInteractor: ConversionInteractionProtocol {
    
    func start() {
        guard started == false else { return }
        
        started = true
        
        service.fetchConversion { [weak self] (response) in
            guard let conversion = response.conversion else { return }
            
            self?.conversion = conversion
            self?.updateBase()
            self?.updatePresentation()
        }
    }
    
}

extension ConversionInteractor: ConversionPresentationDelegate {
    
    func conversionPresentation(_: ConversionPresentationProtocol, didChangeAmountCurrency currency: Currency) {
        if let amount = base {
            base = conversion?.convert(amount: amount, to: currency)
        }
        
        updateBase()
        updatePresentation()
    }
    
    func conversionPresentation(_: ConversionPresentationProtocol, didChangeAmountValue value: Decimal?) {
        base?.value = value
        
        updatePresentation()
    }
    
}

extension ConversionInteractor {
    
    private func updateBase() {
        if let base = base, conversion?.currencies.contains(base.currency) == true {
            return
        }
        
        if let currency = conversion?.currencies.sorted(by: { $0.code < $1.code }).first {
            base = Amount(currency: currency, value: Defaults.baseAmountValue)
        } else {
            base = nil
        }
    }
    
    private func calculateAmounts() -> [Amount] {
        guard let conversion = conversion else { return [] }
        
        if let amount = base {
            return conversion.currencies.map { conversion.convert(amount: amount, to: $0) }
        } else {
            return conversion.currencies.map { Amount(currency: $0, value: nil) }
        }
    }
    
    private func updatePresentation() {
        let amounts = calculateAmounts()
        let model = ConversionPresentationModel(base: base?.currency, amounts: amounts)
        
        presentation.update(with: model)
    }
    
}
