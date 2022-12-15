//
//  MainViewPresenter.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 13.12.2022.
//

import Foundation

final class MainViewPresenter: MainPresenter {

    private let currencyService: CurrencyService
    private let router: Router
    private weak var view: MainView?

    private var currentValue: Double?
    private(set) var selectedCurrency: CurrencyPair?
    private(set) var swappedPairs = false

    init(view: MainView, currencyService: CurrencyService, router: Router) {
        self.view = view
        self.currencyService = currencyService
        self.router = router
    }

    func loadCurrencyList() {
        router.showLoader()
        currencyService.loadList { [weak self] result in
            switch result {
            case .success(_):
                self?.router.hideLoader()

            case .failure(let error):
                self?.router.showAlert(for: error.localizedDescription)
            }
        }
    }

    func loadRates(for pair: String) {
        router.showLoader()
        currencyService.loadRates(for: [pair]) { [weak self] result in
            switch result {
            case .success(let rates):
                self?.selectedCurrency = rates.first(where: { $0.name == pair })
                self?.updateView()
                self?.router.hideLoader()

            case .failure(let error):
                self?.router.showAlert(for: error.localizedDescription)
            }
        }
    }

    func selectCurrency() {
        router.showCurrencyList(with: selectedCurrency?.name) { [weak self] pair in
            self?.loadRates(for: pair)
        }
    }

    func calculate(value: Double?) {
        currentValue = value
        calculate()
    }

    func swapPair(_ flag: Bool) {
        swappedPairs = flag
        updateView()
    }

}

// MARK: - Private

private extension MainViewPresenter {

    func updateView() {
        updatePairsTitle()
        calculate()
    }

    func updatePairsTitle() {
        guard let name = selectedCurrency?.name else {
            return
        }
        let left = name.prefix(3)
        let right = name.suffix(3)
        let sign = swappedPairs ? "<" : ">"
        let title = "\(left) \(sign) \(right)"
        view?.updatePairsTitle(title)
    }

    func calculate() {
        let formatter = NumberFormatter.currencyFormatter
        formatter.maximumFractionDigits = 4

        guard let value = currentValue,
              let result = selectedCurrency?.calculate(value: value, swapped: swappedPairs),
              let text = formatter.string(from: .init(value: result)) else {
            return
        }
        view?.showResult(text)
    }

}
