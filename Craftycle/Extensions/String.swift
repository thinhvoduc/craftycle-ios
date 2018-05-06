//
//  String.swift
//  Craftycle
//
//  Created by Thinh Vo on 06/05/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import Foundation

extension String {
    func toMachineLearningName() -> String {
        guard let id = Int(self) else {
            return "Unknown"
        }
        
        switch id {
        case 0:
            return "Bottle"
        case 1:
            return "Bracelet"
        case 2:
            return "Lighbulb"
        case 3:
            return "T-shirt"
        default:
            return "Unknown"
        }
    }
}
