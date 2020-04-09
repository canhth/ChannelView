//
//  ImageCache.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import UIKit

final class ImageCache {
     
    private var observer: NSObjectProtocol?

    static let shared = ImageCache()

    private init() {
        // Make sure to purge cache on memory pressure
        observer = NotificationCenter.default
            .addObserver(forName: UIApplication.didReceiveMemoryWarningNotification,
                         object: nil,
                         queue: nil,
                         using: { _ in
                            URLCache.shared.removeAllCachedResponses()
            })
    }

    deinit {
        NotificationCenter.default.removeObserver(observer as Any)
    }
    
    func image(request: URLRequest) -> UIImage? {
        if let data = URLCache.shared.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            return image
        }
        Logger.shared.error(object: "This image not stored in disk yet. \(request.url?.absoluteString ?? "")")
        return nil
    }
    
    func save(request: URLRequest, cachedData: CachedURLResponse) {
        // Cleanup the disk if capacity is over 500mb
        if URLCache.shared.currentDiskUsage > 500 * 1024 * 1024 {
            URLCache.shared.removeAllCachedResponses()
        }
        URLCache.shared.storeCachedResponse(cachedData, for: request)
    }
}
