//
//  DetailRouter.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 24.02.2023.
//

import Foundation

class DetailRouter : PresenterToRouterDetailProtocol {
    static func createModule(ref: DetailViewController) {
        let presenter = DetailPresenter()

        //View
        ref.detailPresenterObject = presenter

        //Presenter
        ref.detailPresenterObject?.detailInteractor = DetailInteractor()
        ref.detailPresenterObject?.detailView = ref as? any PresenterToViewDetailProtocol

        //Interactor
        ref.detailPresenterObject?.detailInteractor?.detailPresenter = presenter
    }
}
