//
//  ChannelsTests.swift
//  MindValleyTests
//
//  Created by Canh Tran Wizeline on 4/13/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import XCTest
@testable import MindValley

final class ChannelsTests: MindValleyTests {
    
    private let expectNumberOfSection = 3
    private let viewController = ChannelsViewController()
    private lazy var presenter = ChannelsPresenter(view: viewController,
                                                   interactor: ChannelsInteractor(),
                                                   categoriesInteractor: CategoriesInteractor(),
                                                   router: ChannelsRouter(rootController: UINavigationController()))
    
    override func setUp() {
        super.setUp()
        viewController.presenter = presenter
    }
    
    /// Test Presenter gets list data by network
    func testFetchingDataByNetwork() {
        let expect = expectation(description: "test_listdata_by_network")
        presenter.fetchChannelsInfo()
        DispatchQueue.main.asyncAfter(deadline: .now() + limitTimeOut - 1) {
            expect.fulfill()
        }
        
        waitForExpectations(timeout: limitTimeOut) { [unowned self] error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            } else {
                XCTAssertTrue(self.presenter.numberOfSections() >= 3, "Should load all the section probably")
            }
        }
    }
    
    func testFetchingDataByMockData() {
        let mockInteractor = MockChannelsInteractor()
        let mockCategoiesInteractor = MockCategoriesInteractor()
        presenter = ChannelsPresenter(view: viewController,
                                      interactor: mockInteractor,
                                      categoriesInteractor: mockCategoiesInteractor,
                                      router: ChannelsRouter(rootController: UINavigationController()))
        viewController.presenter = presenter
        
        presenter.fetchChannelsInfo()
        
        XCTAssertTrue(self.presenter.numberOfSections() >= 3, "Should load all the section probably")
    }
    
}
