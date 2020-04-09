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
    let channel: Channel?
    let coverAsset: CoverAsset?
    
    var coverURL: String? {
        return coverAsset?.url
    }
}
