//
//  Extension.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/24/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

extension UITableViewCell: ReusableView {}

protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}

extension Double {

    func toString() -> String {
        return String(format: "%.2f", self)
    }
    
    func round(nearest: Double) -> Double {
        let n = 1 / nearest
        let numberToRound = self * n
        return numberToRound.rounded(.up) / n
    }
}

extension UITableView {

    func register<T: UITableViewCell>(_: T.Type) where T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
}

extension UIView {

    private class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String(describing: self)
        return (Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)?.first as? T) ?? T()
    }

    class func loadNib() -> Self {
        return loadNib(self)
    }
}

extension Notification.Name {
    static let listingDataReset = Notification.Name("listingDataReset")
}
