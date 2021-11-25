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
    
    override func setUpWithError() throws {
        viewController = HomeRouter.createModule()
        presenter = HomePresenter()
        interactor = HomeInteractor()
        
        viewController?.presenter = presenter
        presenter?.viewController = viewController
        presenter?.interactor = interactor
        interactor?.presenter = presenter
    }
    
    override func tearDownWithError() throws {

    }
    
    func testControllerProperties() throws {
        viewController?.trends = [] 
        viewController?.nowPlaying = []
        viewController?.tvPopular = []
    }
    
    func testShowAlert() {
        viewController?.showAlert(title: "test", message: "test", completion: nil)
    }
    
    func testHideLoaddingView() {
        viewController?.hideLoadView()
    }
    
}
