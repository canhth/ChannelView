//
//  Category.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import Foundation

struct Categories: Decodable {
    let categories: [Category]
}

struct Category: Decodable {
    let name: String
}
