//
//  Channel.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import Foundation

struct Channel: Decodable {
    let id: String
    var series = [Series]()
    let title: String
    let mediaCount: Int
    var latestMedia = [Media]()
    let iconAsset: IconAsset?
    let coverAsset: CoverAsset?
    
    var iconURL: String? {
        return iconAsset?.thumbnailUrl
    }
    
    var coverURL: String? {
        return coverAsset?.url
    }
}
