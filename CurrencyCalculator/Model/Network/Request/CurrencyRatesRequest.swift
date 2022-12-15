//
//  CurrencyRatesRequest.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 13.12.2022.
//

import Foundation

struct CurrencyRatesRequest: DataRequest {

    private(set) var queryItems: [String: String] = [
        "get": CurrencyAPI.Query.rates.rawValue,
        "key": CurrencyAPI.key
    ]

    mutating func appendQueryItem(name: String, value: String) {
        queryItems[name] = value
    }

    func decode(_ data: Data) throws -> CurrencyRatesResponse {
        try JSONDecoder().decode(CurrencyRatesResponse.self, from: data)
    }

}
