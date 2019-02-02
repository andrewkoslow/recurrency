//
//  ConversionPresenter.swift
//  Recurrency
//
//  Created by Andrew Koslow on 29/01/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import Foundation

class ConversionPresenter {
    
    private let viewController: ConversionViewControllerProtocol
    
    weak var delegate: ConversionPresentationDelegate?
    
    init(viewController: ConversionViewControllerProtocol) {
        self.viewController = viewController
    }
    
}

extension ConversionPresenter: ConversionPresentationProtocol {
    
    func update(with presentationModel: ConversionPresentationModel) {
        let amounts: [Amount] = presentationModel.amounts.sorted { (first, second) -> Bool in
            return first.currency.code < second.currency.code
        }
        
        let viewModel = ConversionViewModel(amounts: amounts)
        
        viewController.update(with: viewModel)
    }
    
}

extension ConversionPresenter: ConversionViewControllerDelegate {
    
    func conversionViewController(_: ConversionViewControllerProtocol, didChangeAmountValue value: Decimal?) {
        delegate?.conversionPresentation(self, didChangeAmountValue: value)
    }
    
}
