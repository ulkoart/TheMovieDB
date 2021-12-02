//
//  HomeTest.swift
//  TheMovieDBTests
//
//  Created by user on 21.11.2021.
//

import XCTest
@testable import TheMovieDB

class HomeTest: XCTestCase {
    
    var viewController: HomeViewIndicationProtocol?
    var presenter: HomePresenterProtocol?
    var interactor: HomeInteractorProtocol?
    var router: HomeRouter?
    
    override func setUpWithError() throws {
        router = HomeRouter()
        viewController = HomeRouter.createModule()
        presenter = HomePresenter()
        interactor = HomeInteractor()

        viewController?.presenter = presenter
        presenter?.viewController = viewController
        presenter?.router = router
        presenter?.interactor = interactor
        interactor?.presenter = presenter
    }
    
    override func tearDownWithError() throws {
        viewController = nil
        presenter = nil
        interactor = nil
    }
    
    func testControllerProperties() throws {
        viewController?.tableAdapter.trends = []
        viewController?.tableAdapter.nowPlaying = []
        viewController?.tableAdapter.tvPopular = []
    }
    
    func testModuleNotNil() {
        XCTAssertNotNil(viewController, "viewController is not nil")
        XCTAssertNotNil(presenter, "presenter is not nil")
        XCTAssertNotNil(interactor, "interactor is not nil")
        XCTAssertNotNil(router, "router is not nil")
    }
    
    func testShowAlert() {
        viewController?.showAlert(title: "test", message: "test", completion: nil)
    }
    
    func testHideLoaddingView() {
        viewController?.hideLoadView()
    }
    
}
