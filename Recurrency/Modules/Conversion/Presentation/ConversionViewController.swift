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
        let oldModel = self.model
        
        self.model = model
        
        updateTableView(from: oldModel)
    }
    
}

extension ConversionViewController {
    
    private func updateTableView(from oldModel: ConversionViewModel) {
        let oldValues = oldModel.amounts.map { $0.currency.code }
        let newValues = model.amounts.map { $0.currency.code }
        let updates = RowUpdates(oldValues: oldValues, newValues: newValues)
        
        tableView.performBatchUpdates({
            tableView.deleteRows(at: updates.deleteRowIndexPaths, with: .automatic)
            tableView.insertRows(at: updates.insertRowIndexPaths, with: .automatic)
            
            updates.moveRowIndexPaths.forEach({ (move) in
                tableView.moveRow(at: move.from, to: move.to)
            })
            
        })
        
        tableView.indexPathsForVisibleRows?.forEach({ (indexPath) in
            guard let cell = tableView.cellForRow(at: indexPath) as? ConversionViewAmountCell else { return }
            
            update(amountCell: cell, at: indexPath)
        })
    }
    
    private func update(amountCell cell: ConversionViewAmountCell, at indexPath: IndexPath) {
        let amount = model.amounts[indexPath.row]
        
        cell.currency = amount.currency
        cell.amount = amount.amount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.amounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.amountCell, for: indexPath) as! ConversionViewAmountCell
        cell.delegate = self
        
        update(amountCell: cell, at: indexPath)
        
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
