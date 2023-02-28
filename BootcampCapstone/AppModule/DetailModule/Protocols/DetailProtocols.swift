//
//  DetailProtocols.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 24.02.2023.
//

import Foundation

protocol ViewToPresenterDetailProtocol {
    var detailInteractor:PresenterToInteractorDetailProtocol? {get set}
    var detailView:PresenterToViewDetailProtocol? {get set}

    func saveToFoodCart(parameters: [String: Any])
    func getFromFoodCart(parameters: [String: Any])
    func deleteFromFoodCart(parameters: [String : Any], completion: @escaping (Bool) -> Void)

}

protocol PresenterToInteractorDetailProtocol {
    var detailPresenter:InteractorToPresenterDetailProtocol? {get set}

    func saveToFoodCart(parameters: [String: Any])
    func getFromFoodCart(parameters: [String: Any])
    func deleteFromFoodCart(parameters: [String : Any], completion: @escaping (Bool) -> Void)

}

protocol InteractorToPresenterDetailProtocol {
    func sendDataToPresenter(foodsCartArray:[CartFoods])
}

protocol PresenterToViewDetailProtocol {
    func sendDataToView(foodsCartArray:[CartFoods])
}

protocol PresenterToRouterDetailProtocol {
    static func createModule(ref:DetailViewController)
}
