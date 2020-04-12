// 
//  ChannelsInteractor.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation

final class ChannelsInteractor {
    private typealias MediasResponse = [String: [String: [Media]]]
    private typealias ChannelsResponse = [String: [String: [Channel]]]
    
    private let mediaLimit = 6
    
    // MARK: - Private Properties
    private let networkClient: NetworkRequestable

    // MARK: - LifeCycle

    init(networkClient: NetworkRequestable = NetworkClient()) {
        self.networkClient = networkClient
    }
}

// MARK: - ChannelsInteractorInterface

extension ChannelsInteractor: ChannelsInteractorInterface {
    func fetchNewEpisodes(loadFromCache: Bool, completion: @escaping (Result<[Media], NetworkError>) -> Void) {
        self.networkClient.fetch(endPoint: ChannelsAPI.fetchNewEpisodes,
                                 type: MediasResponse.self,
                                 loadFromCache: loadFromCache) { (result) in
                                    DispatchQueue.main.async {
                                        switch result {
                                        case .success(let resultData):
                                            if let data = resultData[NestedKey.data],
                                                let medias = data[NestedKey.media] {
                                                completion(.success(medias))
                                            } else {
                                                completion(.success([]))
                                            }
                                        case .failure(let error):
                                            completion(.failure(error))
                                        }
                                    }
        }
    }
    
    func fetchChannels(loadFromCache: Bool, completion: @escaping (Result<[Channel], NetworkError>) -> Void) {
        self.networkClient.fetch(endPoint: ChannelsAPI.fetchChannels,
                                 type: ChannelsResponse.self,
                                 loadFromCache: loadFromCache) { (result) in
                                    DispatchQueue.main.async {
                                        switch result {
                                        case .success(let resultData):
                                            if let data = resultData[NestedKey.data],
                                                var channels = data[NestedKey.channels] {
                                                // Filter list media not more than 6 items.
                                                DispatchQueue.runBackgroundTask({
                                                    for i in 0..<channels.count {
                                                        if channels[i].latestMedia.count > mediaLimit {
                                                            channels[i].latestMedia = Array(channels[i].latestMedia[0..<mediaLimit])
                                                        }
                                                    }
                                                }, completion: {
                                                    completion(.success(channels))
                                                })
                                            } else {
                                                completion(.success([]))
                                            }
                                        case .failure(let error):
                                            completion(.failure(error))
                                        }
                                    }
        }
    }
}
