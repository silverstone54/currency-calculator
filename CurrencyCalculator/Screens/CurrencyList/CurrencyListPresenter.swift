//
//  CurrencyListPresenter.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 14.12.2022.
//

import Foundation

final class CurrencyListViewPresenter: CurrencyListPresenter {

    private let context: CurrencyListContext
    private let router: Router
    private weak var view: CurrencyListView?

    private(set) var items = [String]()

    var selectedPath: IndexPath? {
        guard let item = context.selectedCurrency, let index = items.firstIndex(of: item) else {
            return nil
        }
        return .init(item: index, section: 0)
    }

    init(context: CurrencyListContext, view: CurrencyListView, router: Router) {
        self.context = context
        self.view = view
        self.router = router
    }

    func loadCurrencyList() {
        context.currencyService.loadList { [weak self] result in
            switch result {
            case .success(let pairs):
                self?.items = pairs
                self?.view?.listLoaded()

            case .failure(let error):
                self?.router.showAlert(for: error.localizedDescription)
            }
        }
    }

    func selectCurrency(at index: Int) {
        context.onSelect?(items[index])
        router.goBack()
    }

}
