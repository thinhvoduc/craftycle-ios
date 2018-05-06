//
//  CLPlacemark.swift
//  Craftycle
//
//  Created by Thinh Vo on 06/05/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import CoreLocation

extension CLPlacemark {
    var title: String {
        let separator = ", "
        var text = ""
        
        if let nameString = self.name {
            text.append(nameString)
        }
        
        if let localityString = self.locality {
            text.append(separator)
            text.append(localityString)
        }
        
        if let countryString = self.country {
            text.append(separator)
            text.append(countryString)
        }
        
        return text
    }
}
