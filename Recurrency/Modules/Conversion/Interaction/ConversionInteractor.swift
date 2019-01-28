//
//  ConversionInteractor.swift
//  Recurrency
//
//  Created by Andrew Koslow on 29/01/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import Foundation

class ConversionInteractor {
    
    private let service: ConversionServiceProtocol
    
    private var started = false
    private var conversion: Conversion?
    
    init(service: ConversionServiceProtocol) {
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
        }
    }
    
}
