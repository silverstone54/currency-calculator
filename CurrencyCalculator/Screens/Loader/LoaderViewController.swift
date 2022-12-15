//
//  LoaderViewController.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 14.12.2022.
//

import UIKit

final class LoaderViewController: UIViewController {

    private var loader: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)

        loader = .init(style: .white)
        loader.startAnimating()
        view.addSubview(loader)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        loader.center = view.center
    }

}
