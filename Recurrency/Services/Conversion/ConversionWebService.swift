//
//  ConversionWebService.swift
//  Recurrency
//
//  Created by Andrew Koslow on 03/02/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import Foundation

class ConversionWebService {
    
    struct Configuration {
        var conversionURL: URL
    }
    
    private let configuration: Configuration
    private let session: URLSession
    
    init(configuration: Configuration, session: URLSession) {
        self.configuration = configuration
        self.session = session
    }
    
}

extension ConversionWebService: ConversionServiceProtocol {
    
    func fetchConversion(completion: @escaping (ConversionResponse) -> Void) {
        let task = session.dataTask(with: configuration.conversionURL) { (data, response, error) in
            var response = ConversionResponse(conversion: nil, error: error)
            
            do {
                if let data = data {
                    response = try JSONDecoder().decode(ConversionResponse.self, from: data)
                }
            } catch let error {
                response = ConversionResponse(conversion: nil, error: error)
            }
            
            DispatchQueue.main.async {
                completion(response)
            }
        }
        
        task.resume()
    }
    
}
