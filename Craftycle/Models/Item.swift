//
//  Item.swift
//  Craftycle
//
//  Created by Thinh Vo on 27/04/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import Foundation

struct Item: Codable {
    var id: Int
    var imageUrl: String?
    var crafted: Bool
    var category: Category
}
