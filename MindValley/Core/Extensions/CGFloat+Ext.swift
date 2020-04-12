//
//  CGFloat+Ext.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/10/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import UIKit
import Foundation

extension CGFloat {
    /**
     The relative dimension to the corresponding screen size.
     */
    var dp: CGFloat {
        let dp = Int(((self / 375) * UIScreen.main.bounds.width))
        return CGFloat(dp)
    }
}
