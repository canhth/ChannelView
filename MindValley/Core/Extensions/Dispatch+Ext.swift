//
//  Dispatch+Ext.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/12/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import Foundation
 
extension DispatchQueue {

    static func runBackgroundTask(_ task: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            task?()
            if let completion = completion {
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
}
