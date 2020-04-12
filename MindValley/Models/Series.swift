//
//  Serie.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import Foundation

struct Series: Decodable {
    let title: String
    let coverAsset: CoverAsset?
    
    var coverURL: String? {
        return coverAsset?.url
    }
}
