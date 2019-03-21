//
//  StyledNavigationController.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/13.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import Foundation
import UIKit

class StyledNavigationController: UINavigationController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
    }
    
    //Init
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    //SetUp Navigation Bar
    private func setupStyle() {
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .white
        navigationBar.barStyle = .black
        navigationBar.setShadowColor(color: .gray)
        
        self.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
    }
    
}
