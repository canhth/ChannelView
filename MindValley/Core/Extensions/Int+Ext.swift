//
//  Int+Ext.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/12/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import UIKit

extension Int {
    func toStringWithPattern(_ pattern: String) -> String {
        let lastCharactor = self <= 1 ? "" : "s"
        return "\(self) " + pattern + lastCharactor
    }
}
