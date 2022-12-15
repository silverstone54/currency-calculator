//
//  CurrencyListViewController.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 14.12.2022.
//

import UIKit

final class CurrencyListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let cellIdentifier = "cell"

    var presenter: CurrencyListPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Currency List"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        presenter.loadCurrencyList()
    }

}

// MARK: - CurrencyListView

extension CurrencyListViewController: CurrencyListView {

    func listLoaded() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.selectRow(at: self.presenter.selectedPath, animated: false, scrollPosition: .middle)
        }
    }

}

// MARK: - UITableViewDataSource

extension CurrencyListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let text = presenter.items[indexPath.item]
        cell.textLabel?.text = text
        return cell
    }

}

// MARK: - UITableViewDelegate

extension CurrencyListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectCurrency(at: indexPath.item)
    }

}
