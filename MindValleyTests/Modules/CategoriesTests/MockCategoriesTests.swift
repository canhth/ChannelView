//
//  MockCategoriesTests.swift
//  MindValleyTests
//
//  Created by Canh Tran Wizeline on 4/13/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import XCTest
@testable import MindValley

final class MockCategoriesInteractor {
    // MARK: - Private Properties
    private typealias CategoriesResponse = [String: [String: [MindValley.Category]]]
    
    private let networkClient: NetworkRequestable

    // MARK: - LifeCycle

    init(networkClient: NetworkRequestable = NetworkClient()) {
        self.networkClient = networkClient
    }
}

// MARK: - ListUsersInteractorInterface

extension MockCategoriesInteractor: CategoriesInteractorInterface {
    func fetchCategories(fromCache: Bool, completion: @escaping (Result<[MindValley.Category], NetworkError>) -> Void) {
        guard let data = TestSuite().data(fromResource: "categories", withExtension: "json") else {
            XCTFail("Can not get the data form categories.json")
            return
        }
        
        do {
            let resultData = try JSONDecoder().decode(CategoriesResponse.self, from: data)
            let categories = resultData[NestedKey.data]?[NestedKey.categories]
            completion(.success(categories ?? []))
            XCTAssertNotNil(categories, "Should load the list categories without error.")
        } catch {
            XCTFail("Can not parse the categories.json")
        }
    }
}
