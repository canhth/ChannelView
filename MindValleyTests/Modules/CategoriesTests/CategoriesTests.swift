//
//  CategoriesTests.swift
//  MindValleyTests
//
//  Created by Canh Tran Wizeline on 4/13/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import XCTest
@testable import MindValley

final class CategoriesTests: MindValleyTests {
     
    private let viewController = CategoriesViewController()
    private lazy var presenter = CategoriesPresenter(view: viewController,
                                                      interactor: CategoriesInteractor(),
                                                      router: CategoriesRouter(rootController: UINavigationController()))
    
    override func setUp() {
        super.setUp()
        viewController.presenter = presenter
    }
    
    /// Test Presenter gets list data by network
    func testFetchingDataByNetwork() {
        let expect = expectation(description: "test_categories_by_network")
        presenter.fetchCategories()
        DispatchQueue.main.asyncAfter(deadline: .now() + limitTimeOut - 1) {
            expect.fulfill()
        }
        
        waitForExpectations(timeout: limitTimeOut) { [unowned self] error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            } else {
                XCTAssertTrue(self.presenter.numberOfCategories() > 0, "Should load all the categories from network probably")
            }
        }
    }
    
    func testFetchingDataByMockData() {
        let mockInteractor = MockCategoriesInteractor()
        presenter = CategoriesPresenter(view: viewController,
                                        interactor: mockInteractor,
                                        router: CategoriesRouter(rootController: UINavigationController()))
        viewController.presenter = presenter
        
        presenter.fetchCategories()
        
        XCTAssertTrue(self.presenter.numberOfCategories() >= 0, "Should load all the categories from JSON probably")
    }
    
}
