//
//  HomeInteractor.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 21.02.2023.
//

import Foundation

class HomeInteractor : PresenterToInteractorHomeProtocol {
    var homePresenter: InteractorToPresenterHomeProtocol?

    func getAll() {
        AlamofireManager.getAll { [weak self] foods in
            self?.homePresenter?.sendDataToPresenter(foodsArray: foods)
        }
    }
}
