//
//  Currency.swift
//  Recurrency
//
//  Created by Andrew Koslow on 29/01/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import Foundation

struct Currency: Hashable {
    
    enum Error: Swift.Error {
        case emptyCode
    }
    
    let code: String
    
    init(code: String) throws {
        guard code.count > 0 else { throw Error.emptyCode }
        
        self.code = code
    }
    
}
