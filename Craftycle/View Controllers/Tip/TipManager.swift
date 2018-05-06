//
//  TipManager.swift
//  Craftycle
//
//  Created by Thinh Vo on 06/05/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import Foundation

enum CategoryType: Int {
    case odlDevice = 0
    case wood = 1
    case paper = 2
    case metal = 3
    case fabric = 4
    case decoration = 5
    case everydayWaste = 6
    case problematicWaste = 7
}

class TipManager {
    class func tips(for category: Category) -> String? {
        guard let categoryType = CategoryType(rawValue: category.id) else { return nil }
        
        switch categoryType {
        case .odlDevice:
            return """
            This is tips for old device
            """
        case .wood:
            return """
            This is tips for wood
            """
        case .paper:
            return """
            This is tips for paper
            """
        case .metal:
            return """
            This is tips for metal
            """
        case .fabric:
            return """
            This is tips for fabric
            """
        case .decoration:
            return """
            This is tips for decoration
            """
        case .everydayWaste:
            return """
            This is tips for everyday waste
            """
        case .problematicWaste:
            return """
            This is tips for problematic waste
            """
        }
    }
}
