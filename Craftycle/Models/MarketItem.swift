//
//  MarketItem.swift
//  Craftycle
//
//  Created by Thinh Vo Duc on 04/05/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import Foundation

struct MarketItem: Codable {
    var id: Int
    var imageUrl: String?
    var crafted: Bool
    var category: Category
    var imageName: String? // For fake data
    var price: Double?
}
