//
//  CartPresenter.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 26.02.2023.
//

import Foundation

class CartPresenter : ViewToPresenterCartProtocol {

    var cartInteractor: PresenterToInteractorCartProtocol?
    var cartView: PresenterToViewCartProtocol?

    func saveToFoodCart(parameters: [String: Any]) {
        cartInteractor?.saveToFoodCart(parameters: parameters)
    }
    func getFromFoodCart(parameters: [String: Any]){
        cartInteractor?.getFromFoodCart(parameters: parameters)
    }
    func deleteFromFoodCart(parameters: [String: Any], completion: @escaping (Bool) -> Void) {
        cartInteractor?.deleteFromFoodCart(parameters: parameters) { success in
            completion(success)
        }
    }

}

extension CartPresenter : InteractorToPresenterCartProtocol {
    func sendDataToPresenter(foodsCartArray: [CartFoods]) {
        cartView?.sendDataToView(foodsCartArray: foodsCartArray)
    }

}
