//
//  NumberFormatter.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 14.12.2022.
//

import Foundation

extension NumberFormatter {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
