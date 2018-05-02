//
//  BaseResponse.swift
//  Craftycle
//
//  Created by Thinh Vo on 18/04/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

class BaseResponse: NSObject, Response {
    var result: Result
    
    var httpStatusCode: Int?
    
    var data: Data?
    
    var error: Error?
    
    init(_ responseData: Data?, response: URLResponse?, responseError: Error?) {
        
        result = Result.from(response: response as? HTTPURLResponse, error: responseError)
        
        httpStatusCode = (response as? HTTPURLResponse)?.statusCode
        
        data = responseData
        
        error = responseError
        
        super.init()
    }
}
