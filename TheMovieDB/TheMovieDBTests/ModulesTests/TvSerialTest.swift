//
//  TvSerialTest.swift
//  TheMovieDBTests
//
//  Created by user on 08.12.2021.
//

import XCTest

class TvSerialTest: XCTestCase {
    var viewController: TvSerialViewControllerProtocol?
    var router: TvSerialRouterProtocol?
    
    override func setUpWithError() throws {
        router = TvSerialRouter()
        viewController = TvSerialRouter.createModule(with: 1)
    }

    override func tearDownWithError() throws {
        viewController = nil
        router = nil
    }
    
    func testModuleNotNil() {
        XCTAssertNotNil(viewController, "viewController is nil")
        XCTAssertNotNil(viewController?.presenter, "presenter is nil")
        XCTAssertNotNil(viewController?.presenter?.interactor, "interactor is nil")
        XCTAssertNotNil(router, "router is nil")
    }

}
