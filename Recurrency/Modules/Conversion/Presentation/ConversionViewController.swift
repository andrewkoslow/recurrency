//
//  ConversionViewController.swift
//  Recurrency
//
//  Created by Andrew Koslow on 29/01/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import UIKit

class ConversionViewController: UITableViewController {
    
    weak var delegate: ConversionPresentationDelegate?
    
    private var model = ConversionPresentationModel(base: nil, amounts: [])
    
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
        
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = 44
    }
    
}

extension ConversionViewController: ConversionPresentationProtocol {
    
    func update(with model: ConversionPresentationModel) {
        let oldModel = self.model
        
        var model = model
        let base = model.base
        
        model.amounts.sort { (first, second) -> Bool in
            if first.currency.code == base?.code { return true }
            else if second.currency.code == base?.code { return false }
            
            return first.currency.code < second.currency.code
        }
        
        self.model = model
        
        updateTableView(from: oldModel)
    }
    
}

extension ConversionViewController {
    
    private func updateTableView(from oldModel: ConversionPresentationModel) {
        let oldValues = oldModel.amounts.map { $0.currency.code }
        let newValues = model.amounts.map { $0.currency.code }
        let updates = RowUpdates(oldValues: oldValues, newValues: newValues)
        
        tableView.performBatchUpdates({
            tableView.deleteRows(at: updates.deleteRowIndexPaths, with: .fade)
            tableView.insertRows(at: updates.insertRowIndexPaths, with: .fade)
            
            updates.moveRowIndexPaths.forEach({ (move) in
                tableView.moveRow(at: move.from, to: move.to)
            })
        })
        
        tableView.indexPathsForVisibleRows?.forEach({ (indexPath) in
            guard let cell = tableView.cellForRow(at: indexPath) as? ConversionViewAmountCell else { return }
            
            cell.amount = model.amounts[indexPath.row]
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.amounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.amountCell, for: indexPath) as! ConversionViewAmountCell
        cell.delegate = self
        cell.amount = model.amounts[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = model.amounts[indexPath.row].currency
        
        delegate?.conversionPresentation(self, didChangeAmountCurrency: currency)
        
        tableView.scrollToNearestSelectedRow(at: .top, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        var result: IndexPath? = indexPath
        
        if tableView.indexPathForSelectedRow == indexPath {
            tableView.deselectRow(at: indexPath, animated: false)
            
            result = nil
        }
        
        return result
    }
    
}

extension ConversionViewController: ConversionViewAmountCellDelegate {
    
    func amountCell(_ cell: ConversionViewAmountCell, didChangeAmountValue value: Decimal?) {
        delegate?.conversionPresentation(self, didChangeAmountValue: value)
    }
    
    func amountCellDidEndEditingAmountValue(_: ConversionViewAmountCell) {
        guard let indexPathForSelectedRow = tableView.indexPathForSelectedRow else { return }
        
        tableView.deselectRow(at: indexPathForSelectedRow, animated: false)
    }
    
}
