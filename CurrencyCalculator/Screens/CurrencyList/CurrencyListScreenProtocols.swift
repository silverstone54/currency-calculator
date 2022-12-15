//
//  CurrencyListScreenProtocols.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 14.12.2022.
//

import Foundation

protocol CurrencyListView: AnyObject {
    func listLoaded()
}

protocol CurrencyListPresenter: AnyObject {
    var items: [String] { get }
    var selectedPath: IndexPath? { get }

    func loadCurrencyList()
    func selectCurrency(at index: Int)
}
