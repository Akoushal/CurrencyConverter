//
//  MainCoordinator.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/13.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    //Default Root Controller for Coordinator
    func defaultRootViewController() -> (rootViewController: CoordinatorManagedViewController, navigationController: UINavigationController?) {
        let vc = ViewController.init()
        let eventHandler = CurrencyConverterEventHandler(view: vc)
        vc.eventHandler = eventHandler
        let nvController = StyledNavigationController(rootViewController: vc)
        return (vc, nvController)
    }
    
    func start() {}
}
