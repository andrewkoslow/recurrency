//
//  ConversionViewAmountCell.swift
//  Recurrency
//
//  Created by Andrew Koslow on 29/01/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import UIKit

protocol ConversionViewAmountCellDelegate: AnyObject {
    
    func amountCell(_: ConversionViewAmountCell, didEnterAmount: Decimal?)
    
}

class ConversionViewAmountCell: UITableViewCell {
    
    weak var delegate: ConversionViewAmountCellDelegate?
    
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
        guard amountTextField.isFirstResponder == false else { return }
        
        amountTextField.text = amountFormatter.string(for: amount)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        amountTextField.isUserInteractionEnabled = isSelected
        updateAmountTextField()
        
        if isSelected {
            amountTextField.becomeFirstResponder()
        } else {
            amountTextField.resignFirstResponder()
        }
    }
    
    @IBAction private func amountTextFieldDidChangeValue() {
        var amount: Decimal?
        
        if let text = amountTextField.text, let decimal = amountFormatter.number(from: text)?.decimalValue, decimal.isFinite == true {
            amount = decimal
        }
        
        delegate?.amountCell(self, didEnterAmount: amount)
    }
    
}
