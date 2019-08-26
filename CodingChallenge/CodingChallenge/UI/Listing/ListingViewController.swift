//
//  ListingViewController.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/21/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import UIKit

class ListingViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private let kEstimatedRowHeight: CGFloat = 44

    // MARK: - Lazy Variables
    lazy var viewModel: ListingViewModel = {
        let viewModel = ListingViewModel()
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

    private func addDataResetObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(resetData),
                                               name: .listingDataReset,
                                               object: nil)
    }

    private func removeDataResetObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .listingDataReset,
                                                  object: nil)
    }

    @objc private func resetData() {
        viewModel.fetchListingFromMockJson()
    }

    deinit {
        removeDataResetObserver()
    }
}

// MARK: - Unbind the View Model Listener
extension ListingViewController {

    //Perfrom UI updates by unbinding from View Model
    func performViewModelActions() {
        viewModel.listingItems.bind {[weak self] (listingItems) in
            guard listingItems.count > 0 else {
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
        viewModel.fetchListingFromMockJson()
    }
}

// MARK: - UITableView Datasource methods
extension ListingViewController: UITableViewDataSource {

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
        cell.cellType = .addButton
        cell.listingItem = (viewModel.listingItems.value[indexPath.row], indexPath)
        return cell
    }
}

// MARK: - ListingViewCell Protocol
extension ListingViewController: ListingViewCellProtocol {

    private func showAlert() {

        let alertController = UIAlertController(title: nil,
                                                message: "Item added in the cart",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok",
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func onClickAddButton(for indexPath: IndexPath?) {
        guard let indexPath = indexPath
        else {
            return
        }
        showAlert()
        viewModel.increaseItemQuantity(for: indexPath)
    }
}
