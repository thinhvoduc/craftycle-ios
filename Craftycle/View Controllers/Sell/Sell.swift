//
//  Sell.swift
//  Craftycle
//
//  Created by iosdev on 2.5.2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

class Sell {
    var sellOrCraft: String
    var photo: UIImage?
    var price: String
    var place: String
    
    //MARK: Initialization
    init?(sellOrCraft: String, photo: UIImage?, place: String, price: String) {
        
        // The labels must not be empty
        guard !sellOrCraft.isEmpty else {
            return nil
        }
        guard !price.isEmpty else {
            return nil
        }
        guard !place.isEmpty else {
            return nil
        }
        
        
        self.sellOrCraft = sellOrCraft
        self.photo = photo
        self.place = place
        self.price = price
        
        
    }
}
