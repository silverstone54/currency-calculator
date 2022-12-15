//
//  AppRouter.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 13.12.2022.
//

import UIKit

protocol Router {
    func showLoader()
    func hideLoader()

    func showCurrencyList(with selectedCurrency: String?)
    func goBack()

    func showAlert(for error: Error)
}

final class RootRouter: Router {

    private let window: UIWindow?
    private let navigationController: UINavigationController
    private var loader: LoaderViewController?
    
    private var currencyService: CurrencyService!
    private weak var mainViewPresenter: MainPresenter?

    init(window: UIWindow?) {
        self.window = window
        self.navigationController = .init()
    }

    func start() {
        let repository = DefaultsRepository()
        let networkService = MainNetworkService()
        currencyService = MainCurrencyService(repository: repository, networkService: networkService)

        let view = MainViewController()
        let presenter = MainViewPresenter(view: view, currencyService: currencyService, router: self)
        view.presenter = presenter

        mainViewPresenter = presenter

        navigationController.viewControllers = [view]

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func showLoader() {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.showLoader()
            }
            return
        }

        guard self.loader == nil else {
            return
        }
        let loader = LoaderViewController()
        loader.modalTransitionStyle = .crossDissolve
        loader.modalPresentationStyle = .overFullScreen
        navigationController.present(loader, animated: false, completion: nil)

        self.loader = loader
    }

    func hideLoader() {
        DispatchQueue.main.async {
            self.loader?.dismiss(animated: true, completion: nil)
            self.loader = nil
        }
    }

    func showCurrencyList(with selectedCurrency: String?) {
        let view = CurrencyListViewController()
        let context = CurrencyListContext(currencyService: currencyService, selectedCurrency: selectedCurrency)
        let presenter = CurrencyListViewPresenter(context: context, view: view, router: self, delegate: self)
        view.presenter = presenter

        navigationController.pushViewController(view, animated: true)
    }

    func goBack() {
        navigationController.popViewController(animated: true)
    }

    func showAlert(for error: Error) {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.showAlert(for: error)
            }
            return
        }
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        navigationController.present(alert, animated: true, completion: nil)
    }

}

// MARK: - CurrencyListPresenterDelegate

extension RootRouter: CurrencyListPresenterDelegate {

    func selectCurrency(_ currency: String) {
        mainViewPresenter?.loadRates(for: currency)
    }

}
