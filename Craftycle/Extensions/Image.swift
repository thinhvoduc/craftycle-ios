//
//  Image.swift
//  Craftycle
//
//  Created by Thinh Vo on 05/04/2018.
//  Copyright © 2018 Thinh. All rights reserved.
//

import UIKit

extension UIImageView {
    func download(_ imageUrl: String) {
        guard let url = URL(string: imageUrl) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data) {
                    self.image = downloadedImage
                }
            }
        }
        
        task.resume()
    }
}
