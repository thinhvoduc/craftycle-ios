//
//  HomeCollectionViewCell.swift
//  Craftycle
//
//  Created by Thinh Vo on 27/04/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    // MARK: Life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.contentMode = .scaleAspectFill
    }
    
    var item: Item? {
        didSet {
            guard let item = item else { return }
            
            if let imageName = item.imageName, let image = UIImage(named: imageName) {
                 imageView.image = image
            } else {
                // NOTE: This might cause heavy downloading issue. We can use SDWebImage library to handle the caches.
                imageView.download(item.imageUrl)
            }
            
            label.isHidden = !item.crafted
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        label.isHidden = true
    }
}
