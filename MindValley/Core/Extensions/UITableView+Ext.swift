//
//  UITableView+Ext.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 3/10/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import UIKit

extension UITableView {
    /**
     Convenience method to register a cell.
     - Parameter cellClass: UITableViewCell class to register.
     */
    func register(_ cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.typeName)
    }
    
    /**
     Convenience method to dequeue a cell knowing it conforms the NameDescribable protocol.
     With this method we only have the fatalError in one place.
     - Parameter indexPath: IndexPath to dequeue cell.
     */
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.typeName, for: indexPath) as? T else {
            fatalError("\(T.typeName) could not be dequeue")
        }
        return cell
    } 
}

extension UICollectionView {
    /**
     Convenience method to register a cell.
     - Parameter cellClass: UICollectionViewCell class to register.
     */
    func register(_ cellClass: UICollectionViewCell.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.typeName)
    }
    
    /**
     Convenience method to dequeue a cell knowing it conforms the NameDescribable protocol.
     With this method we only have the fatalError in one place.
     - Parameter indexPath: IndexPath to dequeue cell.
     */
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.typeName, for: indexPath) as? T else {
            fatalError("\(T.typeName) could not be dequeue")
        }
        return cell
    }
}
