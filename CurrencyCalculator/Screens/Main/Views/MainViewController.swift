//
//  MainViewController.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 13.12.2022.
//

import UIKit

final class MainViewController: UIViewController {

    @IBOutlet private weak var textField: CurrencyTextField!
    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var pairsSwitch: UISwitch!

    var presenter: MainPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Currency Calculator"
        pairsSwitch.isOn = presenter.swappedPairs
        presenter.loadCurrencyList()
    }

    @IBAction private func switchValueChanged(_ sender: UISwitch) {
        presenter.swapPair(sender.isOn)
    }

    @IBAction private func calculateAction(_ sender: Any) {
        textField.resignFirstResponder()
        presenter.calculate(value: textField.doubleValue)
    }

    @IBAction private func selectCurrencyAction(_ sender: Any) {
        textField.resignFirstResponder()
        presenter.selectCurrency()
    }

}

// MARK: - MainView

extension MainViewController: MainView {

    func updatePairsTitle(_ title: String) {
        DispatchQueue.main.async {
            self.currencyLabel.text = title
        }
    }

    func showResult(_ text: String) {
        DispatchQueue.main.async {
            self.resultLabel.text = text
        }
    }

}
