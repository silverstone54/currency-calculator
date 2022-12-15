//
//  CurrencyTextField.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 14.12.2022.
//

import UIKit

final class CurrencyTextField: UITextField {

    private let formatter = NumberFormatter.currencyFormatter

    override var delegate: UITextFieldDelegate? {
        get {
            super.delegate
        }
        set {}
    }

    var doubleValue: Double? {
        guard let text = self.text else {
            return nil
        }
        return formatter.number(from: text)?.doubleValue
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        keyboardType = .decimalPad
        super.delegate = self
    }

}

// MARK: - UITextFieldDelegate

extension CurrencyTextField: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text ?? "") + string

        var fractionDigits = 0
        if let separatorIndex = text.firstIndex(of: Character(formatter.decimalSeparator)) {
            fractionDigits = text.distance(from: separatorIndex, to: text.endIndex) - 1
        }

        if formatter.number(from: text)?.doubleValue != nil {
            return fractionDigits <= formatter.maximumFractionDigits
        }
        return false
    }

}
