//
//  WebServiceError.swift
//  Craftycle
//
//  Created by Thinh Vo on 18/04/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

public enum WebServiceError: Error {
    case serverError
    case noInternetConnection
    case unknown
    case unauthorized
    
    init(rawValue: Int) {
        if rawValue == 1 {
            self = .noInternetConnection
        } else {
            self = .unknown
        }
    }
}
