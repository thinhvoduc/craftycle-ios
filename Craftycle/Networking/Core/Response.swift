//
//  Response.swift
//  Craftycle
//
//  Created by Thinh Vo on 17/04/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import Foundation
import UIKit

public enum Result {
    case success(statusCode: Int)
    case error(statusCode: Int?)
    case noResponse
    
    private static let successCodes: Range<Int> = 200..<299
    
    public static func from(response: HTTPURLResponse?, error: Error?) -> Result {
        if error != nil {
            return Result.error(statusCode: nil)
        }
        
        guard let res = response else {
            return Result.noResponse
        }
        
        return (Result.successCodes.contains(res.statusCode)) ? Result.success(statusCode: res.statusCode) : Result.error(statusCode: res.statusCode)
    }
    
    public var statusCode: Int? {
        switch self {
        case .success(let statusCode):
            return statusCode
        case .error(let statusCode?):
            return statusCode
        default:
            return nil
        }
    }
}

public protocol Response: NSObjectProtocol {
    
    /// Type of response. Success or failure
    var result: Result { get }
    
    /// Return HTTP status code of the response
    var httpStatusCode: Int? { get }
    
    /// Response data
    var data: Data? { get }
    
    /// Error
    var error: Error? { get }
    /// Timeline
//    var timeline: Timeline? { get }
}
