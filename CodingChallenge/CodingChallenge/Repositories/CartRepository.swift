//
//  CartRepository.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/21/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import Foundation

typealias GetCartResult = Result<[ListingItem], ErrorResult>
typealias GetCartCompletion = (_ result: GetCartResult) -> Void

// MARK: - Cart Repository
class CartRepository: CartDataProtocol {

    let worker: CoreDataWorker

    init(worker: CoreDataWorker = CoreDataWorker()) {
        self.worker = worker
    }

    func fetchAllCartItems(completion: @escaping ([CartItem]?) -> Void) {
        worker.get { (result: Result<[CartItem], Error>) in
            switch result {
            case .success(let items):
                completion(items)
            case .failure(let error):
                print("\(error)")
                completion(nil)
            }
        }
    }

    func fetchCartItem(itemId: String, completion: @escaping (CartItem?) -> Void) {
        let predicate = NSPredicate(format: "identifier == %@", itemId)
        worker.get (with: predicate, completion: { (result: Result<[CartItem], Error>) in
            switch result {
            case .success(let items):
                completion(items.first)
            case .failure(let error):
                print("\(error)")
                completion(nil)
            }
        })
    }

    func updateCartItem(cartItem: CartItem?) {
        guard let cartItem = cartItem else { return }
        if cartItem.quantity > 0 {
            worker.upsert(entities: [cartItem]) { (error) in
                guard let error = error else { return }
                print("\(error)")
            }
        } else {
            deleteCartItem(cartItem: cartItem)
        }
    }

    func increaseQuantityFor(listingItem: ListingItem?) {
        guard let id = listingItem?.id else {return}
        fetchCartItem(itemId: String(id)) { [weak self] (cartItem) in
            if var objToUpdate = cartItem {
                objToUpdate.quantity += 1
                self?.updateCartItem(cartItem: objToUpdate)
            } else {
                self?.updateCartItem(listingItem: listingItem, quantity: 1)
            }
        }
    }

    func decreaseQuantityFor(listingItem: ListingItem?) {
        guard let id = listingItem?.id else {return}
        fetchCartItem(itemId: String(id)) { [weak self] (cartItem) in
            if var objToUpdate = cartItem {
                objToUpdate.quantity -= 1
                self?.updateCartItem(cartItem: cartItem)
            }
        }
    }

    func updateCartItem(listingItem: ListingItem?, quantity: Int?) {
        guard let listItem = listingItem, let qty = quantity else {return}
     let cartItem = CartItem(listItem: listItem, quantity: qty)
         updateCartItem(cartItem: cartItem)
    }

    func deleteCartItem(cartItem: CartItem?) {
        guard let cartItem = cartItem else { return }
        worker.delete(entity: cartItem) { (error) in
            guard let error = error else { return }
            print("\(error)")
        }
    }

    func removeAllItems() {
        worker.deleteAllRecords(entityName: CartItemMo.self) { (error) in
            guard let error = error else { return }
            print("\(error)")
        }
    }
}
