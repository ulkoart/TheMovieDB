//
//  TvSerialPresenter.swift
//  TheMovieDB
//
//  Created by user on 15.11.2021.
//

import Foundation

typealias TvSerialViewIndicationProtocol = TvSerialViewController & IndicationViewControllerProtocol

protocol TvSerialPresenterProtocol: AnyObject {
    var viewController: TvSerialViewIndicationProtocol? { get set }
    var interactor: TvSerialInteractorProtocol? { get set }
    var router: TvSerialRouterProtocol? { get set }
    
    func loadData(tvSerialId: Int)
    func loadDataSuccess(tvSerialDetail: TvSerialDetailResponse, tvSerialCredits: TvSerialCreditsResponse)
    func loadDataFailure(errorString: String)
}

final class TvSerialPresenter: TvSerialPresenterProtocol {
    weak var viewController: TvSerialViewIndicationProtocol?
    var interactor: TvSerialInteractorProtocol?
    var router: TvSerialRouterProtocol?
    
    func loadData(tvSerialId: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showLoadView()
        }
        interactor?.retrieveData(tvSerialId: tvSerialId)
    }
    
    func loadDataSuccess(tvSerialDetail: TvSerialDetailResponse, tvSerialCredits: TvSerialCreditsResponse) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.hideLoadView()
             self?.viewController?.configureData(tvSerialDetail: tvSerialDetail, tvSerialCredits: tvSerialCredits)
             self?.viewController?.reloadData()
        }
    }
    
    func loadDataFailure(errorString: String) {
        self.viewController?.dataFailure(text: errorString)
    }
}
