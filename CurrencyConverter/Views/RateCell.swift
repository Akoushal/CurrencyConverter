//
//  RateCell.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/18.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import UIKit

class RateCell: UITableViewCell {
    
    //IBOutlets
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    var currencyCode: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //Update Cell
    func configureCell(currencyRate: Rates, eventHandler: CurrencyConverterEventHandler, controller: ViewController) {
        selectionStyle = .none
        currencyCode = currencyRate.currencyInfo.currencyCode
        currencyCodeLabel.text = currencyRate.currencyInfo.currencyCode
        currencyNameLabel.text = currencyRate.currencyInfo.currencyFullname
        flagImageView.image = currencyRate.currencyInfo.flagImage
        
        guard !eventHandler.delegates.contains(where: { $0.value == self}) else { return }
        eventHandler.delegates.append(Weak(value: self))
        
        amountTextField.addTarget(controller, action: #selector(ViewController.textFieldDidChange(textField:)), for: .editingChanged)
    }

    //Mark: - Private Methods
    
    //Selected Cell
    private func configureAsInputCell() {
        amountTextField.isUserInteractionEnabled = true
        amountTextField.becomeFirstResponder()
    }
    
    //Unselected Cells
    private func configureAsDisplayCell() {
        amountTextField.isUserInteractionEnabled = false
        amountTextField.resignFirstResponder()
    }
    
    private func updateCurrencyAmountTextField(amountToConvert: Double, conversionRate: Double) {
        let fmt = NumberFormatter()
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.maximumFractionDigits = 2
        fmt.minimumFractionDigits = 0
        fmt.minimumIntegerDigits = 1
        
        let number = NSNumber(value: amountToConvert * conversionRate)
        amountTextField.text = fmt.string(from: number)
    }
    
    //Toolbar Done Button Action
    @objc func doneWithNumberPad() {
        amountTextField.resignFirstResponder()
    }
}

//Mark: - CurrencyConverterEventHandler Delegates
extension RateCell {
    @objc func updateCurrentCurrency(newBaseCurrency: String) {
        guard newBaseCurrency == currencyCode else {
            configureAsDisplayCell()
            return
        }
        configureAsInputCell()
    }
    
    //Update Textfield
    func updateRateAndAmount(from newRates: [Rates], currentBaseCurrency: String, amountToConvert: Double) {
        guard let newRateInfo = newRates.first(where: { [weak self] in
            guard let self = self else { return false}
            return $0.currencyInfo.currencyCode == self.currencyCode
        }), currentBaseCurrency != currencyCode else { return }
        
        updateCurrencyAmountTextField(amountToConvert: amountToConvert,
                                      conversionRate: newRateInfo.conversionRate)
    }
}
