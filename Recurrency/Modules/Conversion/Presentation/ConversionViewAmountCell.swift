//
//  ConversionViewAmountCell.swift
//  Recurrency
//
//  Created by Andrew Koslow on 29/01/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import UIKit

protocol ConversionViewAmountCellDelegate: AnyObject {
    
    func amountCell(_: ConversionViewAmountCell, didChangeAmountValue: Decimal?)
    func amountCellDidEndEditingAmountValue(_: ConversionViewAmountCell)
    
}

class ConversionViewAmountCell: UITableViewCell {
    
    weak var delegate: ConversionViewAmountCellDelegate?
    
    var amount: Amount? {
        didSet {
            updateCurrencyCodeLabel()
            updateAmountTextField()
        }
    }
    
    @IBOutlet private var currencyCodeLabel: UILabel!
    @IBOutlet private var amountTextField: UITextField!
    
    private let amountPresentationFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        return formatter
    }()
    
    private let amountEditingFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.zeroSymbol = ""
        formatter.nilSymbol = ""
        formatter.notANumberSymbol = ""
        
        return formatter
    }()
    
    private let amountParsingFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.isPartialStringValidationEnabled = true
        formatter.isLenient = true
        
        return formatter
    }()
    
    private func updateCurrencyCodeLabel() {
        currencyCodeLabel.text = amount?.currency.code
    }
    
    private func updateAmountTextField() {
        guard amountTextField.isFirstResponder == false else { return }
        
        let formatter = isSelected ? amountEditingFormatter : amountPresentationFormatter
        
        amountTextField.text = formatter.string(for: amount?.value)
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
        var value: Decimal?
        
        if let text = amountTextField.text, let decimal = amountParsingFormatter.number(from: text)?.decimalValue, decimal.isFinite == true {
            value = decimal
        }
        
        delegate?.amountCell(self, didChangeAmountValue: value)
    }
    
    @IBAction private func amountTextFieldDidEndEditing() {
        delegate?.amountCellDidEndEditingAmountValue(self)
    }
    
}
