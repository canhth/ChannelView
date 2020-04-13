//
//  Media.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import Foundation

enum MediaType: String, Decodable {
    case course
    case video
}

struct Media: Decodable {
    
    let type: MediaType
    let title: String
    let coverAsset: CoverAsset?
    
    private let channel: ChannelName?
    
    var coverURL: String? {
        return coverAsset?.url
    }
    
    private struct ChannelName: Decodable {
        let title: String
    }
    
    var channelName: String {
        return channel?.title ?? ""
    }
}
