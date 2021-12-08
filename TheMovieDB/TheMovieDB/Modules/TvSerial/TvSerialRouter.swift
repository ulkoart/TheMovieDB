//
//  TvSerialRouter.swift
//  TheMovieDB
//
//  Created by user on 15.11.2021.
//

import UIKit

protocol TvSerialRouterProtocol: AnyObject {
    static func createModule(with tvSerialId: Int) -> TvSerialViewController
}

final class TvSerialRouter: TvSerialRouterProtocol {
    static func createModule(with tvSerialId: Int) -> TvSerialViewController {
        let viewController = TvSerialViewController(tvSerialId: tvSerialId)
        let presenter = TvSerialPresenter()
        let interactor = TvSerialInteractor()
        let router = TvSerialRouter()
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return viewController
    }
}
