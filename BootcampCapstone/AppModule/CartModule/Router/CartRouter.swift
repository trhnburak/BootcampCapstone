//
//  CartRouter.swift
//  BootcampCapstone
//
//  Created by Burak Turhan on 26.02.2023.
//

import Foundation

class CartRouter : PresenterToRouterCartProtocol {
    static func createModule(ref: CartViewController) {
        let presenter = CartPresenter()

        //View
        ref.cartPresenterObject = presenter

        //Presenter
        ref.cartPresenterObject?.cartInteractor = CartInteractor()
        ref.cartPresenterObject?.cartView = ref as? any PresenterToViewCartProtocol

        //Interactor
        ref.cartPresenterObject?.cartInteractor?.cartPresenter = presenter
    }
}
