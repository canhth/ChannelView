//
//  NetworkClient.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 5/5/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation

/// A definition of a NetworkClient
public protocol NetworkRequestable {
    func fetch<T: Decodable>(endPoint: APIEndpoint,
                             type: T.Type,
                             loadFromCache: Bool,
                             completion: @escaping (Result<T, NetworkError>) -> Void)
}

/// A type represents network client
public final class NetworkClient: NetworkRequestable {

    public typealias NetworkClientResponse<T> = (Result<T, NetworkError>) -> Void

    private let session: URLSession
    
    /// Creates an instance of network client
    ///
    /// - Parameter session: The URLSession that coordinates a group of related network data transfer tasks
    public init(session: URLSession = URLSession.shared) {
        self.session = session
        // Make sure to purge cache on memory pressure
        let cacheDirectory = (NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String).appendingFormat("/\(Bundle.main.bundleIdentifier ?? "cache")/" )
        
        let urlCache = URLCache(memoryCapacity: 50 * 1024 * 1024,
                                diskCapacity: 500 * 1024 * 1024,
                                diskPath: cacheDirectory)
        
        URLCache.shared = urlCache
    }

    /// Fetches a network request with a relevant `Decodable.Type`to decode the response.
    ///
    /// - Parameters:
    ///   - endPoint: The endpoint to fetch
    ///   - type: The decode closure that expects a `Decodable` object and returns a relevant type
    ///   - completion: The completion handler of the request
    public func fetch<T: Decodable>(endPoint: APIEndpoint,
                                    type: T.Type,
                                    loadFromCache: Bool,
                                    completion: @escaping NetworkClientResponse<T>) {
        guard let request = endPoint.buildRequest() else {
            completion(.failure(.unableToGenerateURLRequest))
            return
        }
        
        // Load from disk if device is not connect to network
        if loadFromCache || !Reachability.isConnectedToNetwork() {
            loadFromCached(endPoint: endPoint, request: request, completion: completion)
        }

        let task = session.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response,
                let httpResponse = response as? HTTPURLResponse else {
                if let error = error {
                    completion(.failure(.fetchError(error: error)))
                } else {
                    // Throw invalidResponse if there is no data, http response or error
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            // Check the status code is in range
            guard 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.noSuccessResponse(code: "\(httpResponse.statusCode)")))
                return
            }

            let cachedResponse = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedResponse, for: request)
            
            self.parseData(endPoint: endPoint, data: data, completion: completion)
        }

        task.resume()
    }
    
    // MARK: - Private
    
    /// Try to load the request in cached.
    private func loadFromCached<T: Decodable>(endPoint: APIEndpoint,
                                              request: URLRequest,
                                              completion: @escaping NetworkClientResponse<T>) {
        if let data = URLCache.shared.cachedResponse(for: request)?.data {
            parseData(endPoint: endPoint, data: data, completion: completion)
        } else {
            completion(.failure(.cachedNotFound))
        }
    }
    
    /// The step to parse Data to Object model.s
    private func parseData<T: Decodable>(endPoint: APIEndpoint,
                                         data: Data,
                                         completion: @escaping NetworkClientResponse<T>) {
        do {
            let genericModel = try endPoint.jsonDecoder.decode(T.self, from: data)
            completion(.success(genericModel))
        } catch {
            completion(.failure(.badDeserialization))
        }
    }
}
