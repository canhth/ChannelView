//
//  UIViewController+Ext.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 3/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import UIKit

extension UIViewController {
    func validateOnPresent(_ controller: UIViewController) -> Bool {
        switch (controller.presentingViewController, presentedViewController) {
        case (.some(let parent), _):
            Logger.shared.error(object: "\(controller) is being presented by \(parent) already.")
            return false
        case (_, .some(let child)):
            Logger.shared.error(object: "`\(self)` is presenting another \(child) already.")
            return false
        default:
            return true
        }
    }
    
    func aa() {
        
    }
    
    /// Apply large title for navigation bar
    /// - Parameter title: Navigation title
    func preferLargeTitleNavigationBar(enable: Bool,
                                       with title: String,
                                       displayMode: UINavigationItem.LargeTitleDisplayMode = .always) {
        navigationItem.title = title
        navigationController?.view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = enable
        navigationController?.navigationItem.largeTitleDisplayMode = displayMode
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 46)
        ]
    }
}
