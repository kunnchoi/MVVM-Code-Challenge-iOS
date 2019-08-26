//
//  ReceiptViewCell.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/21/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import UIKit

class ReceiptViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!

    private func setUpUI(with item: ListingItemViewModel) {
        if item.quantity > 0 {
            let count = "\(item.quantity)"
            let imported = item.imported == true ? " imported" : ""
            let name = " \(item.name ?? ""): "
            let price = ((item.price ?? 0) + (item.saleTaxPrice ?? 0) + (item.importedTaxPrice ?? 0))
            let totalPrice = Double(item.quantity) * price
            nameLabel.text = count + " *" + imported + name + "$\(totalPrice.toString())"
        }
    }

    // MARK: - Vairables
    var listingItem: (ListingItemViewModel, IndexPath)? {
        didSet {
            guard let data = listingItem else {
                return
            }
            let item = data.0
            setUpUI(with: item)
        }
    }
}

extension ReceiptViewCell: NibLoadableView {}
