//
//  DataRequest.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 13.12.2022.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol DataRequest {
    associatedtype Response

    var url: String { get }
    var method: HTTPMethod { get }
    var queryItems: [String: String] { get }

    mutating func appendQueryItem(name: String, value: String)
    func decode(_ data: Data) throws -> Response
}

extension DataRequest {
    var url: String {
        CurrencyAPI.url
    }

    var method: HTTPMethod {
        .get
    }

    var queryItems: [String: String] {
        [:]
    }
}
