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
            - Recycle as problematic waste.
            - Parts can be used as spare.
            - You can sell or give away your materials on our sellpage!
            """
        case .wood:
            return """
            - Take to recycling points which handle wood.
            - You can sell or give away your materials on our sellpage!
            """
        case .paper:
            return """
            - Paper and cardboard are recycled separately.
            - You can craft for example origami, cards, bookmarks from paper.
            - Cardboard can be used in many ways in craftings.
            - You can sell or give away your materials on our sellpage!
            """
        case .metal:
            return """
            - Small everyday metal can be recycled in most recycling points, but bigger stuff has to be taken to special recycling points.
            - You can sell or give away your materials on our sellpage!
            """
        case .fabric:
            return """
            - Clothes that are in good shape and clean can be sold at flea markets or taken to clothing collection points.
            - From old fabrics you can make blankets, toys or rags.
            - You can sell or give away your materials on our sellpage!
            """
        case .decoration:
            return """
            - Sort depending on the material into glass, metal, plastic etc. and take them to your closest recycling point.
            - From glass bottles you can make candle stands and from colorful glass jewellery.
            - You can sell or give away your materials on our sellpage!
            """
        case .everydayWaste:
            return """
            - Sort depending on the material into plastic, metal, etc. and take them to your closest recycling point.
            - You can make bags from coffee packets and other packing materials.
            - You can sell or give away your materials on our sellpage!
            """
        case .problematicWaste:
            return """
            - Never throw problematic waste with mixed waste.
            - Separate batteries, light bulbs, devices etc. on their own and take them to recycling points which handle problematic waste.
            - You can sell or give away your materials on our sellpage!
            """
        }
    }
}
