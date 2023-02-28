//
//  HomePresenter.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 21.02.2023.
//

import Foundation

class HomePresenter : ViewToPresenterHomeProtocol {
    var homeInteractor: PresenterToInteractorHomeProtocol?
    var homeView: PresenterToViewHomeProtocol?

    func getAll() {
        homeInteractor?.getAll()
    }

}

extension HomePresenter : InteractorToPresenterHomeProtocol {
    func sendDataToPresenter(foodsArray: [Foods]) {
        homeView?.sendDataToView(foodsArray: foodsArray)
    }
}
