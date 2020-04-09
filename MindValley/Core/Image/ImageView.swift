//
//  ImageView.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import UIKit

extension UIImageView {

    func loadImage(url: String) {
        guard let URL = URL(string: url) else { return }
        
        let request = URLRequest(url: URL)
        
         
        DispatchQueue.global(qos: .userInitiated).async {
            // Always load image from memory first.
            if let cachedImage = ImageCache.shared.image(request: request) {
                self.transition(toImage: cachedImage)
                return
            }
            self.loadImageFromNetwork(request: request)
        }
    }
    
    private func loadImageFromNetwork(request: URLRequest) {
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                Logger.shared.error(object: "Couldn't download image: \(error)")
                return
            }
            
            guard
                let data = data,
                let response = response,
                let image = UIImage(data: data) else {
                    Logger.shared.error(object: "Unable to parse image: \(String(describing: request.url))")
                return
            }
            
            let cachedData = CachedURLResponse(response: response, data: data)
            ImageCache.shared.save(request: request, cachedData: cachedData)
            
            DispatchQueue.main.async {
                self.transition(toImage: image)
            }
            
        }).resume()
    }
    
    private func transition(toImage image: UIImage?) {
        UIView.transition(with: self,
                          duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: { self.image = image },
                          completion: nil)
    }
}
