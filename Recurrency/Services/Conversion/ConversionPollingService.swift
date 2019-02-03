//
//  ConversionPollingService.swift
//  Recurrency
//
//  Created by Andrew Koslow on 03/02/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import Foundation

class ConversionPollingService {
    
    struct Configuration {
        var pollingInterval: Int
    }
    
    private let configuration: Configuration
    private let service: ConversionServiceProtocol
    
    private var completion: ((ConversionResponse) -> Void)?
    
    init(configuration: Configuration, service: ConversionServiceProtocol) {
        self.configuration = configuration
        self.service = service
    }
    
}

extension ConversionPollingService: ConversionServiceProtocol {
    
    private func fetchConversion() {
        service.fetchConversion { [weak self] (response) in
            self?.completion?(response)
            
            let deadline = DispatchTime.now() + DispatchTimeInterval.seconds(self?.configuration.pollingInterval ?? 0)
            
            DispatchQueue.main.asyncAfter(deadline: deadline, execute: { [weak self] in
                self?.fetchConversion()
            })
        }
    }
    
    func fetchConversion(completion: @escaping (ConversionResponse) -> Void) {
        self.completion = completion
        
        fetchConversion()
    }
    
}
