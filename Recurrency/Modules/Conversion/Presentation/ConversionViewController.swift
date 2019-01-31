//
//  ConversionViewController.swift
//  Recurrency
//
//  Created by Andrew Koslow on 29/01/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import UIKit

class ConversionViewController: UITableViewController {
    
    weak var delegate: ConversionViewControllerDelegate?
    
    private var model = ConversionViewModel(amounts: [])
    
}

extension ConversionViewController {
    
    private struct ReuseIdentifiers {
        static let amountCell = "AmountCell"
    }
    
}

extension ConversionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let amountCellNib = UINib(nibName: "ConversionViewAmountCell", bundle: nil)
        
        tableView.register(amountCellNib, forCellReuseIdentifier: ReuseIdentifiers.amountCell)
    }
    
}

extension ConversionViewController: ConversionViewControllerProtocol {
    
    func update(with model: ConversionViewModel) {
        self.model = model
        
        tableView.reloadData()
    }
    
}

extension ConversionViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.amounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let amount = model.amounts[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.amountCell, for: indexPath) as! ConversionViewAmountCell
        cell.currency = amount.currency
        cell.amount = amount.amount
        cell.delegate = self
        
        return cell
    }
    
}

extension ConversionViewController: ConversionViewAmountCellDelegate {
    
    func amountCell(_ cell: ConversionViewAmountCell, didEnterAmount value: Decimal?) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let currency = model.amounts[indexPath.row].currency
        let amount = ConversionViewModel.Amount(currency: currency, amount: value)
        
        delegate?.conversionViewController(self, didChangeAmount: amount)
    }
    
}
