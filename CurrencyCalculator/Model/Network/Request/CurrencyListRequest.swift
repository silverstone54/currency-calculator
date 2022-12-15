//
//  CurrencyListRequest.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 13.12.2022.
//

import Foundation

struct CurrencyListRequest: DataRequest {

    private(set) var queryItems: [String: String] = [
        "get": CurrencyAPI.Query.currencyList.rawValue,
        "key": CurrencyAPI.key
    ]

    mutating func appendQueryItem(name: String, value: String) {
        queryItems[name] = value
    }

    func decode(_ data: Data) throws -> CurrencyListResponse {
        try JSONDecoder().decode(CurrencyListResponse.self, from: data)
    }
    
}
