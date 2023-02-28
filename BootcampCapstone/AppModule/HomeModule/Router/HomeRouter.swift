//
//  HomeRouter.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 21.02.2023.
//

import Foundation

class HomeRouter : PresenterToRouterHomeProtocol {
    static func createModule(ref: HomeViewController) {
        let presenter = HomePresenter()

        //View
        ref.homePresenterObject = presenter

        //Presenter
        ref.homePresenterObject?.homeInteractor = HomeInteractor()
        ref.homePresenterObject?.homeView = ref

        //Interactor
        ref.homePresenterObject?.homeInteractor?.homePresenter = presenter
    }
}
