//
//  Asset.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import Foundation

struct IconAsset: Decodable {
    let thumbnailUrl: String?
    let url: String?
}

struct CoverAsset: Decodable {
    let url: String?
}
