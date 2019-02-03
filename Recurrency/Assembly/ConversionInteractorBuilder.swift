//
//  ConversionInteractorBuilder.swift
//  Recurrency
//
//  Created by Andrew Koslow on 03/02/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import UIKit

class ConversionInteractorBuilder {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func build() -> ConversionInteractionProtocol {
        let viewController = ConversionViewController(style: .grouped)
        
        let conversionURL = URL(string: "https://revolut.duckdns.org/latest?base=EUR")!
        let webServiceConfiguration = ConversionWebService.Configuration(conversionURL: conversionURL)
        let webService = ConversionWebService(configuration: webServiceConfiguration, session: URLSession.shared)
        
        let pollingServiceConfiguration = ConversionPollingService.Configuration(pollingInterval: 1)
        let pollingService = ConversionPollingService(configuration: pollingServiceConfiguration, service: webService)
        
        let interactor = ConversionInteractor(presentation: viewController, service: pollingService)
        
        viewController.delegate = interactor
        
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        viewController.navigationItem.largeTitleDisplayMode = .always
        viewController.navigationItem.title = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
        
        window.rootViewController = navigationController
        
        
        return interactor
    }
    
}
