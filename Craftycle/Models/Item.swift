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
    var imageName: String?
    
    static func samples() -> [Item]? {
        guard let url = Bundle.main.url(forResource: "Items", withExtension: "json"), let itemsData = try? Data(contentsOf: url) else {
            return nil
        }
        
        var items: [Item]?
        
        items = try? JSONDecoder().decode([Item].self, from: itemsData)
    
        return items
    }
}
