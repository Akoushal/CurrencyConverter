//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/21.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CoordinatorManaged {
    
    // MARK:- Properties
    var eventHandler: CurrencyConverterEventHandler?
    
    lazy var actIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(UINib(nibName: RateCell.uniqueIdentifier, bundle: nil), forCellReuseIdentifier: RateCell.uniqueIdentifier)
        return tv
    }()
    
    // MARK:- Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Configuration.title
        view.backgroundColor = .white
        view.addSubview(actIndicator)
        view.addSubview(tableView)
        
        // Setting Constraints for the tableview
        tableView.edgesAnchorEqualTo(destinationView: view).activate()
        
        // Auto layout for UIActivityIndicatorView
        let horizontalConstraint = actIndicator
            .centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let verticalConstraint = actIndicator
            .centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
        
        //Register Keyboard Notifications
        registerKeyboardNotifications()
        
        showActivityIndicator()
        
        //Call API
        eventHandler?.configure()
    }
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    //Activity Indicator Visibility Methods
    private func showActivityIndicator() {
        tableView.alpha = 0.0
        actIndicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        actIndicator.stopAnimating()
        tableView.alpha = 1.0
    }
}

//Mark: - UITableView DataSource
extension ViewController: UITableViewDataSource
{
    //Total number of currencies is the response from API + base currency
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventHandler?.numberOfCurrency() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RateCell.uniqueIdentifier, for: indexPath) as? RateCell else{
            return UITableViewCell()
        }
        // Configure the cell
        DispatchQueue.main.async { [weak self, weak cell] in
            guard let self = self, let cell = cell else { return}
            if let currencyRate = self.eventHandler?.getCurrencyRate(forRow: indexPath.row), let eventHandler = self.eventHandler {
                cell.configureCell(currencyRate: currencyRate, eventHandler: eventHandler, controller: self)
                cell.updateCurrentCurrency(newBaseCurrency: eventHandler.getCurrentBaseCurrency())
            }
        }
        
        return cell
    }
}

//MArk: - UITableView Delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0 else { return}
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? RateCell else { return}
        if let newAmount = selectedCell.amountTextField.text {
            eventHandler?.move(startIndex: indexPath.row, destinationIndex: 0, newAmount: Double(newAmount) ?? 0)
        }
        
        // Move selected cell & scroll to top
        tableView.beginUpdates()
        tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        tableView.endUpdates()
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

//Mark: - Insert Data In Table
extension ViewController: CurrencyConverterViewControllerProtocol {
    func insertData(at indexPathArray: [IndexPath]) {
        hideActivityIndicator()
        guard !indexPathArray.isEmpty else { return }
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: indexPathArray, with: .none)
        self.tableView.endUpdates()
    }
}

extension ViewController {
    //Callback for textfield text change
    @objc func textFieldDidChange(textField: UITextField) {
        guard let text = textField.text else { return }
        guard !text.isEmpty else {
            eventHandler?.updateAmountToConvert(0)
            return
        }
        
        if let amount = NumberFormatter().number(from: text)?.doubleValue {
            eventHandler?.updateAmountToConvert(amount)
        }
    }
}

//Mark: - Keyboard Hide/Show
extension ViewController {
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
