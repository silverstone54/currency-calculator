//
//  CurrencyListContext.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 14.12.2022.
//

import Foundation

struct CurrencyListContext {
    let currencyService: CurrencyService
    let selectedCurrency: String?
    let onSelect: ((String) -> Void)?
}
