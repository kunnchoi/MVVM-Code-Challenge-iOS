//
//  ListingViewCell.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/21/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import UIKit

enum ListingViewCellType {
    case addButton
    case counter
}

protocol ListingViewCellProtocol: class {

    func onClickAddButton(for indexPath: IndexPath?)
    func onClickIncreaseButton(for indexPath: IndexPath?)
    func onClickDecreaseButton(for indexPath: IndexPath?)
}

extension ListingViewCellProtocol {

    func onClickAddButton(for indexPath: IndexPath?) {}
    func onClickIncreaseButton(for indexPath: IndexPath?) {}
    func onClickDecreaseButton(for indexPath: IndexPath?) {}
}

class ListingViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var importedLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var counterStackView: UIStackView!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    weak var delegate: ListingViewCellProtocol?

    // MARK: - Vairables
    var listingItem: (ListingItemViewModel, IndexPath)? {
        didSet {
            guard let data = listingItem else {
                return
            }
            let item = data.0
            nameLabel.text = item.name ?? ""
            priceLabel.text = "Price $\(item.price?.toString() ?? "--")"
            descLabel.text = "\(item.desc ?? "")"
            importedLabel.isHidden = item.imported == false
            countLabel.text = "\(item.quantity)"
        }
    }

    var cellType: ListingViewCellType? {
        didSet {
            counterStackView.isHidden = cellType == .counter ? false : true
            addButton.isHidden = cellType == .addButton ? false : true
        }
    }

    // MARK: - Actions
    @IBAction func onClickAddButton(_ sender: Any) {

        delegate?.onClickAddButton(for: listingItem?.1)
    }

    @IBAction func onClickIncreaseButton(_ sender: Any) {

        delegate?.onClickIncreaseButton(for: listingItem?.1)
    }

    @IBAction func onClickDecreaseButton(_ sender: Any) {

        delegate?.onClickDecreaseButton(for: listingItem?.1)
    }
}

extension ListingViewCell: NibLoadableView {}
