//
//  HomeProtocols.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 21.02.2023.
//

import Foundation

protocol ViewToPresenterHomeProtocol {
    var homeInteractor:PresenterToInteractorHomeProtocol? {get set}
    var homeView:PresenterToViewHomeProtocol? {get set}

    func getAll()

}

protocol PresenterToInteractorHomeProtocol {
    var homePresenter:InteractorToPresenterHomeProtocol? {get set}

    func getAll()

}

protocol InteractorToPresenterHomeProtocol {
    func sendDataToPresenter(foodsArray:[Foods])
}

protocol PresenterToViewHomeProtocol {
    func sendDataToView(foodsArray:[Foods])
}

protocol PresenterToRouterHomeProtocol {
    static func createModule(ref:HomeViewController)
}
