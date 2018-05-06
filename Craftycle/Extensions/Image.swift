//
//  Image.swift
//  Craftycle
//
//  Created by Thinh Vo on 05/04/2018.
//  Copyright © 2018 Thinh. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    func download(_ imageUrl: String?) {
        guard let stringUrl = imageUrl, let url = URL(string: stringUrl) else { return }
        
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data else {
//                return
//            }
//
//            DispatchQueue.main.async {
//                if let downloadedImage = UIImage(data: data) {
//                    self.image = downloadedImage
//                }
//            }
//        }
//
//        task.resume()
        
        sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions.cacheMemoryOnly, completed: nil)
    }
}
