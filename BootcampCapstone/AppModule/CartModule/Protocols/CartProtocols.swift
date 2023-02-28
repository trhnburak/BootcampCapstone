//
//  CartProtocol.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 26.02.2023.
//

import Foundation

protocol ViewToPresenterCartProtocol {
    var cartInteractor:PresenterToInteractorCartProtocol? {get set}
    var cartView:PresenterToViewCartProtocol? {get set}

    func saveToFoodCart(parameters: [String: Any])
    func getFromFoodCart(parameters: [String: Any])
    func deleteFromFoodCart(parameters: [String : Any], completion: @escaping (Bool) -> Void)

}

protocol PresenterToInteractorCartProtocol {
    var cartPresenter:InteractorToPresenterCartProtocol? {get set}

    func saveToFoodCart(parameters: [String: Any])
    func getFromFoodCart(parameters: [String: Any])
    func deleteFromFoodCart(parameters: [String : Any], completion: @escaping (Bool) -> Void)

}

protocol InteractorToPresenterCartProtocol {
    func sendDataToPresenter(foodsCartArray:[CartFoods])
}

protocol PresenterToViewCartProtocol {
    func sendDataToView(foodsCartArray:[CartFoods])
}

protocol PresenterToRouterCartProtocol {
    static func createModule(ref:CartViewController)
}
