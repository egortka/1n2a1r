//
//  CustomImageView.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 12/03/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastImageUrlUsedToLoadImage: String?
    
    func loadImage(with urlString: String) {
        
        // set image to nil
        self.image = nil
        
        // set lastImageUrlUsedToLoadImage
        lastImageUrlUsedToLoadImage = urlString
        
        // check if image exist in cache
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        // if image does not exist
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // handle error
            if let error = error {
                print("Failed to load image from url: ", error.localizedDescription)
                return
            }
            
            if self.lastImageUrlUsedToLoadImage != url.absoluteString {
                return
            }
            
            // handle image data
            guard let imageData = data else { return }
            
            // set image to cache
            let loadedImage = UIImage(data: imageData)
            imageCache[urlString] = loadedImage
            
            // set image to image view
            DispatchQueue.main.async {
                self.image = loadedImage
            }
            }.resume()
    }
}
