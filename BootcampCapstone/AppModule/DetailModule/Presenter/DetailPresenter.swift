//
//  DetailPresenter.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 24.02.2023.
//

import Foundation

class DetailPresenter : ViewToPresenterDetailProtocol {

    var detailInteractor: PresenterToInteractorDetailProtocol?
    var detailView: PresenterToViewDetailProtocol?

    func saveToFoodCart(parameters: [String: Any]) {
        detailInteractor?.saveToFoodCart(parameters: parameters)
    }
    func getFromFoodCart(parameters: [String: Any]){
        detailInteractor?.getFromFoodCart(parameters: parameters)
    }
    func deleteFromFoodCart(parameters: [String: Any], completion: @escaping (Bool) -> Void) {
        detailInteractor?.deleteFromFoodCart(parameters: parameters) { success in
            completion(success)
        }
    }

}

extension DetailPresenter : InteractorToPresenterDetailProtocol {
    func sendDataToPresenter(foodsCartArray: [CartFoods]) {
        detailView?.sendDataToView(foodsCartArray: foodsCartArray)
    }

}
