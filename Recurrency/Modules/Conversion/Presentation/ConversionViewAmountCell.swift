//
//  ConversionViewAmountCell.swift
//  Recurrency
//
//  Created by Andrew Koslow on 29/01/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import UIKit

class ConversionViewAmountCell: UITableViewCell {
    
    var currency: Currency? {
        didSet {
            updateCurrencyCodeLabel()
        }
    }
    var amount: Decimal? {
        didSet {
            updateAmountTextField()
        }
    }
    
    @IBOutlet private var currencyCodeLabel: UILabel!
    @IBOutlet private var amountTextField: UITextField!
    
    private let amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        return formatter
    }()
    
    private func updateCurrencyCodeLabel() {
        currencyCodeLabel.text = currency?.code
    }
    
    private func updateAmountTextField() {
        amountTextField.text = amountFormatter.string(for: amount)
    }
    
}
