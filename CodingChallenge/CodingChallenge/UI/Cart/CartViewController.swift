//
//  CartViewController.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/21/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import UIKit

class CartViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var checkOutButton: UIButton!
    private let kEstimatedRowHeight: CGFloat = 44

    // MARK: - Lazy Variables

    lazy var viewModel: CartViewModel = {
        let viewModel = CartViewModel()
        return viewModel
    }()

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        performViewModelActions()
    }

    private func setUpTableView() {
        tableView.register(ListingViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = kEstimatedRowHeight
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
}

// MARK: - Unbind the View Model Listener
extension CartViewController {

    //Perfrom UI updates by unbinding from View Model
    func performViewModelActions() {
        viewModel.listingItems.bind {[weak self] (listingItems) in
            guard listingItems.count > 0 else {
                self?.disableCheckOutButton()
                return
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        // Update the status label
        viewModel.statusDescription.bind {[weak self] (descript) in
            guard let state = descript else {
                return
            }
            DispatchQueue.main.async {
                if state.1 {
                    self?.activityIndicator.stopAnimating()
                } else {
                    self?.activityIndicator.startAnimating()
                }
                //self?.statusLbl.text = state.0
            }
        }
        viewModel.fetchListingFromDB()
    }
}
// MARK: - UITableView Datasource methods
extension CartViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.listingItems.value.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListingViewCell.defaultReuseIdentifier,
                                                       for: indexPath) as? ListingViewCell
        else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.cellType = .counter
        cell.listingItem = (viewModel.listingItems.value[indexPath.row], indexPath)
        return cell
    }
}

// MARK: - ListingViewCell Protocol
extension CartViewController: ListingViewCellProtocol {

    private func disableCheckOutButton() {

        checkOutButton.isEnabled = false
        checkOutButton.alpha = 0.5
    }

    func onClickIncreaseButton(for indexPath: IndexPath?) {
        viewModel.increaseItemQuantity(for: indexPath)
    }

    func onClickDecreaseButton(for indexPath: IndexPath?) {
        if viewModel.decreaseItemQuantity(for: indexPath) {
            tableView.reloadData()
            disableCheckOutButton()
        }
    }
}
