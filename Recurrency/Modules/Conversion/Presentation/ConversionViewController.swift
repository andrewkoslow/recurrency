//
//  ConversionViewController.swift
//  Recurrency
//
//  Created by Andrew Koslow on 29/01/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import UIKit

class ConversionViewController: UITableViewController {
    
    private var model = ConversionViewModel(amounts: [])
    
}

extension ConversionViewController: ConversionViewControllerProtocol {
    
    func update(with model: ConversionViewModel) {
        self.model = model
        
        tableView.reloadData()
    }
    
}
