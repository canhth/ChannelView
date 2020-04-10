//
//  ChannelsAPI.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import Foundation

enum NestedKey {
    static let data = "data"
    static let categories = "categories"
    static let channels = "channels"
    static let media = "media"
}

enum ChannelsAPI {
    case fetchNewEpisodes
    case fetchChannels
    case fetchCategories
}

// MARK: Confirm protocol Endpoint

extension ChannelsAPI: APIEndpoint {
    var method: HTTPMethod {
        return .get
    }

    var path: String {
        switch self {
        case .fetchNewEpisodes: return "raw/z5AExTtw"
        case .fetchChannels: return "raw/Xt12uVhM"
        case .fetchCategories: return "raw/A0CgArX3"
        }
    }

    var parameters: Parameters? {
        return nil
    }
}
