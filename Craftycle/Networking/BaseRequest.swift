//
//  BaseRequest.swift
//  Craftycle
//
//  Created by Thinh Vo on 18/04/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

class BaseRequest: NSObject, Request {
    var headers: HTTPHeaders?
    
    var method: HTTPMethod
    
    var endpoint: String
    
    var queryParams: Parameters?
    
    var pathParams: Parameters?
    
    var timeOut: TimeInterval?
    
    var body: RequestBody?
    
    var cachePolicy: URLRequest.CachePolicy?
    
    init(httpMethod: HTTPMethod, endpointString: String, queryParameters: Parameters?, pathParameters: Parameters?, requestBody: RequestBody?) {
        method = httpMethod
        endpoint = endpointString
        queryParams = queryParameters
        pathParams = pathParameters
        body = requestBody
        
        super.init()
    }
}
