//
//  UIFont+Ext.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import UIKit

enum MVFont {
    
    static let headLine = bold(ofSize: 30)
    
    static let section = black(ofSize: 20)
    
    static let channelSection = bold(ofSize: 20)
    
    static let subSection = medium(ofSize: 16)
    
    static let title = bold(ofSize: 17)
    
    static let category = bold(ofSize: 18)
    
    static let subTitle = bold(ofSize: 13)
    
    private enum Roboto {
        static let black = "Roboto-Black"
        static let bold = "Roboto-Bold"
        static let light = "Roboto-Light"
        static let medium = "Roboto-Medium"
        static let regular = "Roboto-Regular"
    }
    
    private static func regular(ofSize: CGFloat) -> UIFont {
        return customFont(name: Roboto.regular, ofSize: ofSize)
    }
    
    private static func black(ofSize: CGFloat) -> UIFont {
        return customFont(name: Roboto.black, ofSize: ofSize)
    }
    
    private static func medium(ofSize: CGFloat) -> UIFont {
        return customFont(name: Roboto.medium, ofSize: ofSize)
    }
    
    private static func bold(ofSize: CGFloat) -> UIFont {
        return customFont(name: Roboto.bold, ofSize: ofSize)
    }
    
    private static func light(ofSize: CGFloat) -> UIFont {
        return customFont(name: Roboto.light, ofSize: ofSize)
    }
    
    private static func customFont(name: String, ofSize: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: ofSize)
        assert(font != nil, "Can't load font: \(name)")
        return font ?? UIFont.systemFont(ofSize: ofSize)
    }
}
