//
//  MockChannelsTests.swift
//  MindValleyTests
//
//  Created by Canh Tran Wizeline on 4/13/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import XCTest
@testable import MindValley

final class MockChannelsInteractor {
    // MARK: - Private Properties
    private typealias MediasResponse = [String: [String: [Media]]]
    private typealias ChannelsResponse = [String: [String: [Channel]]]
    
    private let networkClient: NetworkRequestable

    // MARK: - LifeCycle

    init(networkClient: NetworkRequestable = NetworkClient()) {
        self.networkClient = networkClient
    }
}

// MARK: - ListUsersInteractorInterface

extension MockChannelsInteractor: ChannelsInteractorInterface {
    
    func fetchNewEpisodes(loadFromCache: Bool, completion: @escaping (Result<[Media], NetworkError>) -> Void) {
        guard let data = TestSuite().data(fromResource: "newepisodes", withExtension: "json") else {
            XCTFail("Can not get the data form newepisodes.json")
            return
        }
        
        do {
            let resultData = try JSONDecoder().decode(MediasResponse.self, from: data)
            let medias = resultData[NestedKey.data]?[NestedKey.media]
            completion(.success(medias ?? []))
            XCTAssertNotNil(medias, "Should load the list media without error.")
        } catch {
            XCTFail("Can not parse the newepisodes.json")
        }
    }
    
    func fetchChannels(loadFromCache: Bool, completion: @escaping (Result<[Channel], NetworkError>) -> Void) {
        guard let data = TestSuite().data(fromResource: "listchannels", withExtension: "json") else {
            XCTFail("Can not get the data form listchannels.json")
            return
        }
        
        do {
            let resultData = try JSONDecoder().decode(ChannelsResponse.self, from: data)
            let channels = resultData[NestedKey.data]?[NestedKey.channels]
            
            completion(.success(channels ?? []))
            XCTAssertNotNil(channels, "Should load the list channels without error.")
        } catch {
            XCTFail("Can not parse the listchannels.json")
        }
    }
     
}
