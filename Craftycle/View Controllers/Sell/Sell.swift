//
//  Sell.swift
//  Craftycle
//
//  Created by iosdev on 2.5.2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

// TODO: Remove this Sell class
class Sell {
    var sellOrCraft: String?
    var photo: UIImage?
    var price: Double?
    var place: String?
    var emailContact: String?
    //MARK: Initialization
    init?(sellOrCraft: String, photo: UIImage?, place: String?, price: Double?, emailContact: String?) {
        
        
        self.sellOrCraft = sellOrCraft
        self.photo = photo
        self.place = place
        self.price = price
        self.emailContact = emailContact
        
    }
}

extension Sell: CustomStringConvertible {
    var description: String {
        return "\(price ?? 0) €, \(place ?? "Unknown Location"), \(emailContact ?? "Unknown Contact")"
    }
}
