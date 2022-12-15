//
//  MainScreenProtocols.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 14.12.2022.
//

import Foundation

protocol MainView: AnyObject {
    func updatePairsTitle(_ title: String)
    func showResult(_ text: String)
}

protocol MainPresenter: AnyObject {
    var swappedPairs: Bool { get }

    func loadCurrencyList()
    func loadRates(for pair: String)

    func selectCurrency()
    func calculate(value: Double?)
    func swapPair(_ flag: Bool)
}
