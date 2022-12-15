//
//  DefaultsStorage.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 13.12.2022.
//

import Foundation

enum RepositoryName: String {
    case currencyList
    case rates
}

protocol Repository {
    func load<Model: Decodable>(from repository: RepositoryName) -> Model?
    func save<Model: Encodable>(_ model: Model, to repository: RepositoryName)
}

final class DefaultsRepository: Repository {

    func load<Model: Decodable>(from repository: RepositoryName) -> Model? {
        guard let data = UserDefaults.standard.value(forKey: repository.rawValue) as? Data else {
            return nil
        }
        return try? JSONDecoder().decode(Model.self, from: data)
    }

    func save<Model: Encodable>(_ model: Model, to repository: RepositoryName) {
        guard let data = try? JSONEncoder().encode(model) else {
            return
        }
        UserDefaults.standard.setValue(data, forKey: repository.rawValue)
    }

}
