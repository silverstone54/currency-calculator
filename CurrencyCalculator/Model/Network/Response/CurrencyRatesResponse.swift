//
//  CurrencyRatesResponse.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 13.12.2022.
//

import Foundation

struct CurrencyRatesResponse: Decodable {
    let data: [String: String]
}
