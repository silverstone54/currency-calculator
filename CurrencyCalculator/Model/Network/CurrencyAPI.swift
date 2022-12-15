//
//  CurrencyAPI.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 13.12.2022.
//

import Foundation

struct CurrencyAPI {

    static let url = "https://currate.ru/api/"
    static let key = "452b5c12f9142eec3572da309d22ee5f"

    enum Query: String {
        case currencyList = "currency_list"
        case rates
        case pairs
    }

}
