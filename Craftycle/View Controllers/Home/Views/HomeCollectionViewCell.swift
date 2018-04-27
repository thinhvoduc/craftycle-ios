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
    
    var item: Item? {
        didSet {
            guard let item = item else { return }
            
            imageView.download(item.imageUrl)
            
            label.isHidden = !item.crafted
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        label.isHidden = true
    }
}
