//
//  CurrencyStorage.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 13.12.2022.
//

import Foundation

enum StorageName: String {
    case currency
    case rates
}

final class DefaultsStorage {

    func load<T: Decodable>(from storage: StorageName) -> T? {
        guard let data = UserDefaults.standard.value(forKey: storage.rawValue) as? Data else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func save<T: Encodable>(_ model: T, to storage: StorageName) {
        guard let data = try? JSONEncoder().encode(model) else {
            return
        }
        UserDefaults.standard.setValue(data, forKey: storage.rawValue)
    }

}
