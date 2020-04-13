//
//  Collection+Ext.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/13/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
