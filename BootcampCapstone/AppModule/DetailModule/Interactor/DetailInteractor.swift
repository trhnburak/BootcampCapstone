//
//  DetailInteractor.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 24.02.2023.
//

import Foundation

class DetailInteractor : PresenterToInteractorDetailProtocol {
    var detailPresenter: InteractorToPresenterDetailProtocol?

    func getFromFoodCart(parameters: [String : Any]) {
        AlamofireManager.getAllForFoodCart(parameters: parameters) { [weak self] cartFoods in
            self?.detailPresenter?.sendDataToPresenter(foodsCartArray: cartFoods)
        }
    }

    func saveToFoodCart(parameters: [String: Any]){
        AlamofireManager.saveToFoodCart(parameters: parameters)
    }

    func deleteFromFoodCart(parameters: [String : Any], completion: @escaping (Bool) -> Void) {
        AlamofireManager.deleteFromTheFoodCart(parameters: parameters) { success in
            if success {
                // The delete request was successful
                completion(true)
            } else {
                // The delete request failed
                completion(false)
            }
        }
    }
}

