//
//  ReceiptViewController.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/21/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import UIKit

class ReceiptViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    private weak var footerView: ReceiptFooterView?
    private let kEstimatedRowHeight: CGFloat = 44

    // MARK: - Lazy Variables

    lazy var viewModel: ReceiptViewModel = {
        let viewModel = ReceiptViewModel()
        return viewModel
    }()

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        performViewModelActions()
    }

    @IBAction func purchaseBtnClicked(_ sender: Any) {
        let alertController = UIAlertController(title: nil,
                                                message: "Thank you for your purchase!",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Continue Shopping",
                                                style: .default,
                                                handler: { [weak self] (_) in
            NotificationCenter.default.post(name: .listingDataReset,
                                            object: nil)
            self?.viewModel.purchaseSussessUpdate()
            self?.navigationController?.popToRootViewController(animated: false)
        }))
        present(alertController, animated: true, completion: nil)
    }

    private func setUpTableView() {
        tableView.register(ReceiptViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = kEstimatedRowHeight
        footerView = ReceiptFooterView.loadNib()
        tableView.tableFooterView = footerView
    }
}

// MARK: - Unbind the View Model Listener
extension ReceiptViewController {

    //Perfrom UI updates by unbinding from View Model
    func performViewModelActions() {
        viewModel.listingItems.bind {[weak self] (listingItems) in
            guard listingItems.count > 0 else {
                return
            }
            DispatchQueue.main.async {
                guard let this = self
                else { return }
                this.tableView.reloadData()
                this.footerView?.saleTaxLabel.text = "$\( this.viewModel.getTotalSaleTax().toString())"
                this.footerView?.totalPriceLabel.text = "$\( this.viewModel.getTotalPrice().toString())"
            }
        }
        viewModel.fetchListingFromDB()
    }
}

// MARK: - UITableView Datasource methods
extension ReceiptViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.listingItems.value.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceiptViewCell.defaultReuseIdentifier,
                                                       for: indexPath) as? ReceiptViewCell
            else {
                return UITableViewCell()
        }
        cell.listingItem = (viewModel.listingItems.value[indexPath.row], indexPath)
        return cell
    }
}
