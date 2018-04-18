//
//  AuthenticatedService.swift
//  Craftycle
//
//  Created by Thinh Vo on 17/04/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

public enum AuthorizationHeader {
    case basic(base64String: String?)
    case bearerToken(token: String?)
    case custom(headerKey: String, headerValue: String?, headerValueGenerator: ((String?)->String)?)
}

public protocol AuthenticatedService {
    var authorizationHeader: AuthorizationHeader? { get set }
}
