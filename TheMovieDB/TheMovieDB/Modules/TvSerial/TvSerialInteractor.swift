//
//  TvSerialInteractor.swift
//  TheMovieDB
//
//  Created by user on 15.11.2021.
//

import Foundation

protocol TvSerialInteractorProtocol: AnyObject {
    var presenter: TvSerialPresenterProtocol? { get set }
    
    func retrieveData(tvSerialId: Int)
}

final class TvSerialInteractor: TvSerialInteractorProtocol {
    weak var presenter: TvSerialPresenterProtocol?
    
    private var service: TMDBNetworkServiceProtocol = TMDBNetworkService.shared
    private let dispatchGroup = DispatchGroup()
    private var tvSerialDetail: TvSerialDetailResponse?
    private var tvSerialCredits: TvSerialCreditsResponse?
    
    func retrieveData(tvSerialId: Int) {
        retrieveTvSerialData(tvSerialId: tvSerialId)
    }
    
    private func retrieveTvSerialData(tvSerialId: Int) {
        dispatchGroup.enter()
        service.getTvSerialDetail(tvSerialId: tvSerialId) { self.processGetTvSerialDetail($0) }
        
        dispatchGroup.enter()
        service.getTvSerialCredits(tvSerialId: tvSerialId) { self.processGetTvSerialCredits($0) }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let tvSerialDetail = self?.tvSerialDetail else { return }
            guard let tvSerialCredits = self?.tvSerialCredits else { return }
            self?.presenter?.loadDataSuccess(tvSerialDetail: tvSerialDetail, tvSerialCredits: tvSerialCredits)
        }
    }
    
    private func processGetTvSerialDetail(_ response: GetTvSerialDetailResponse) {
        dispatchGroup.leave()
        switch response {
        case .success(let data):
            tvSerialDetail = data
        case .failure(let error):
            presenter?.loadDataFailure(errorString: error.message)
        }
    }
    
    private func processGetTvSerialCredits(_ response: GetTvSerialCreditsResponse) {
        dispatchGroup.leave()
        switch response {
        case .success(let data):
            tvSerialCredits = data
        case .failure(let error):
            presenter?.loadDataFailure(errorString: error.message)
        }
    }
}
