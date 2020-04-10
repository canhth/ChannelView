//
//  UIView+Ext.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 3/10/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import UIKit

extension UIView {
    
    /**
     It helps you to programmatically set the constrains of a view.
     You just need to apply it to the view to be set and pass a set of parameters described below:
     - Parameter top: anchor of the view that will be anchored to the top (optional if you pass nil).
     - Parameter left: anchor of the view that will be anchored to the left (optional if you pass nil).
     - Parameter bottom: anchor of the view that will be anchored to the bottom (optional if you pass nil).
     - Parameter right: anchor of the view that will be anchored to the right (optional if you pass nil).
     - Parameter paddingTop: padding from the view's top anchor to the anchored top anchor (optional if you pass 0).
     - Parameter paddingLeft: padding from the view's left anchor to the anchored left anchor (optional if you pass 0).
     - Parameter paddingBottom: padding from the view's bottom anchor to the anchored bottom anchor (optional if you pass 0).
     - Parameter paddingRight: padding from the view's right anchor to the anchored right anchor (optional if you pass 0).
     - Parameter width: fixed width of the view (optional if you pass 0).
     - Parameter width: fixed height of the view (optional if you pass 0).
     
     ** NOTE: We're not going to support Arabic or Hebrew so keep simple to use left/right.
     ### Usage Example: ###
     ````
     viewToBeAnchored.anchor(top: oneView.topAnchor,
     left: otherView.leftAnchor,
     bottom: nil,
     right: otherView.rightAnchor,
     paddingTop: 8,
     paddingLeft: 16,
     paddingBottom: 0,
     paddingRight: 16,
     width: 0,
     height: 0)
     ````
     */
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0.0,
                paddingLeft: CGFloat = 0.0,
                paddingBottom: CGFloat = 0.0,
                paddingRight: CGFloat = 0.0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    /// Set horizontal center with another view
    /// - Parameter layoutXAnchor: the collaborating view's XAxis anchor with current view
    func anchorCenter(horizontal: NSLayoutXAxisAnchor? = nil, vertical: NSLayoutYAxisAnchor? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let horizontal = horizontal {
            centerXAnchor.constraint(equalTo: horizontal).isActive = true
        }
        if let vertical = vertical {
            centerYAnchor.constraint(equalTo: vertical).isActive = true
        }
    }
    
    /// Set width height divine ratio anchor.
    /// - Parameter ratioValue: the ratio value to constraint between width & height. It is equal width DIVINE height
    func anchorRatio(_ ratioValue: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: ratioValue).isActive = true
    }
    
    /**
     Programmatically pins the view (sets the top, bottom, left and right anchors) to it's parent's anchors with an optional padding.
     - Parameter padding: padding between the view to be anchored and it's parent view.
     */
    func pinToSuperview(padding: UIEdgeInsets = .zero) {
        anchor(top: superview?.topAnchor,
               left: superview?.leftAnchor,
               bottom: superview?.bottomAnchor,
               right: superview?.rightAnchor,
               paddingTop: padding.top,
               paddingLeft: padding.left,
               paddingBottom: padding.bottom,
               paddingRight: padding.right)
    }
}

extension NSLayoutConstraint {
    @discardableResult
    func set(active: Bool) -> Self {
        isActive = active
        return self
    }
    
    @discardableResult
    func set(priority: UILayoutPriority) -> Self {
        self.priority = priority
        return set(active: true)
    }
}
