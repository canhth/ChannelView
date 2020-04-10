//
//  String+Ext.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 3/11/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import UIKit

extension String {
    func getEstimateFrame(width: CGFloat, height: CGFloat) -> CGSize {
        let size = CGSize(width: width, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimateFrame = NSString(string: self).boundingRect(with: size,
                                                                options: options,
                                                                attributes: [.font: UIFont.systemFont(ofSize: 15)],
                                                                context: nil)
        return estimateFrame.size
    }
}
