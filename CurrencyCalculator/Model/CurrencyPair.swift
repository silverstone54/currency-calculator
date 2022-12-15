//
//  CurrencyPair.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 13.12.2022.
//

import Foundation

struct CurrencyPair: Codable {
    let name: String
    var rate: Rate?

    func calculate(value: Double, swapped: Bool) -> Double? {
        guard let rateValue = rate?.value else {
            return nil
        }
        return swapped ? value / rateValue : value * rateValue
    }
}

struct Rate: Codable {
    let value: Double
    let refreshDate: Date
}
