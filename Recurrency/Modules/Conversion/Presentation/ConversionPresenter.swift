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
    
    init(viewController: ConversionViewControllerProtocol) {
        self.viewController = viewController
    }
    
}

extension ConversionPresenter: ConversionPresentationProtocol {
    
    func update(with presentationModel: ConversionPresentationModel) {
        let amounts: [ConversionViewModel.Amount] = presentationModel.amounts
            .sorted { (first, second) -> Bool in
                return first.key.code < second.key.code
            }
            .map { (data) -> ConversionViewModel.Amount in
                return ConversionViewModel.Amount(currency: data.key, amount: data.value)
        }
        
        let viewModel = ConversionViewModel(amounts: amounts)
        
        viewController.update(with: viewModel)
    }
    
}
