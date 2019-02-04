//
//  URL+JSON.swift
//  RecurrencyTests
//
//  Created by Andrew Koslow on 04/02/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import Foundation

extension URL {
    
    init?(json: [String : Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []) else { return nil }
        guard let dataURL = URL(dataRepresentation: data, relativeTo: nil) else { return nil }
        
        let source = "data:application/json," + dataURL.absoluteString
        
        self.init(string: source)
    }
    
}
