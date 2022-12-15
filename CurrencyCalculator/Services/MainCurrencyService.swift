//
//  CurrencyService.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 13.12.2022.
//

import Foundation

protocol CurrencyService {
    func loadList(completion: @escaping (Result<[String], Error>) -> Void)
    func loadRates(for pairs: [String], completion: @escaping (Result<[CurrencyPair], Error>) -> Void)
}

final class MainCurrencyService: CurrencyService {

    private let repository: Repository
    private let networkService: NetworkService

    private let cacheUpdateInterval: TimeInterval = 3600
    private var refreshListDate: Date? {
        get {
            UserDefaults.standard.object(forKey: #function) as? Date
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }

    private var pairs = [String]()
    private var rates = [String: Rate]()

    init(repository: Repository, networkService: NetworkService) {
        self.repository = repository
        self.networkService = networkService

        loadData()
    }

    func loadList(completion: @escaping (Result<[String], Error>) -> Void) {
        guard needUpdateCache(refreshDate: refreshListDate) else {
            completion(.success(pairs))
            return
        }

        let request = CurrencyListRequest()

        networkService.request(request) { [weak self] result in
            switch result {
            case .success(let response):
                let pairs = response.data
                self?.pairs = pairs
                self?.refreshListDate = Date()
                self?.repository.save(pairs, to: .currencyList)
                completion(.success(pairs))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadRates(for pairs: [String], completion: @escaping (Result<[CurrencyPair], Error>) -> Void) {
        guard needUpdateRates(for: pairs) else {
            let rates = prepareRates(for: pairs)
            completion(.success(rates))
            return
        }

        var request = CurrencyRatesRequest()
        let value = pairs.joined(separator: ",")
        request.appendQueryItem(name: CurrencyAPI.Query.pairs.rawValue, value: value)

        networkService.request(request) { [weak self] result in
            switch result {
            case .success(let response):
                guard let strongSelf = self else {
                    return
                }
                for (key, value) in response.data {
                    if let doubleValue = Double(value) {
                        let rate = Rate(value: doubleValue, refreshDate: Date())
                        strongSelf.rates[key] = rate
                    }
                }
                strongSelf.repository.save(strongSelf.rates, to: .rates)

                let result = strongSelf.prepareRates(for: pairs)
                completion(.success(result))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

// MARK: - Private

private extension MainCurrencyService {

    func loadData() {
        pairs = repository.load(from: .currencyList) ?? []
        rates = repository.load(from: .rates) ?? [:]
    }

    func needUpdateRates(for pairs: [String]) -> Bool {
        if rates.isEmpty {
            return true
        }
        var update = false
        for pair in pairs {
            if let rate = rates[pair] {
                if needUpdateCache(refreshDate: rate.refreshDate) {
                    update = true
                    break
                }
            } else {
                update = true
                break
            }
        }
        return update
    }

    func needUpdateCache(refreshDate: Date?) -> Bool {
        guard let date = refreshDate else {
            return true
        }
        let interval = Date().timeIntervalSince(date)
        return interval > cacheUpdateInterval
    }

    func prepareRates(for pairs: [String]) -> [CurrencyPair] {
        var result = [CurrencyPair]()
        pairs.forEach {
            var currency = CurrencyPair(name: $0)
            currency.rate = rates[$0]
            result.append(currency)
        }
        return result
    }

}
