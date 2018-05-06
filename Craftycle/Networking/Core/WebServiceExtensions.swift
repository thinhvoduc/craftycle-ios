//
//  WebServiceExtensions.swift
//  Craftycle
//
//  Created by Thinh Vo on 17/04/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import Foundation

public extension Dictionary where Key == String, Value == Any? {
    public func urlEncodedString(base: String = "") throws -> String {
        guard self.count > 0 else { return "" }
        let items: [URLQueryItem] = self.flatMap { (key,value) in
            guard let v = value else { return nil }
            return URLQueryItem(name: key, value: String(describing: v))
        }
        var urlComponents = URLComponents(string: base)!
        urlComponents.queryItems = items
        guard let encodedString = urlComponents.url else {
            throw EncodingError.dataIsNotEncodable(self)
        }
        return encodedString.absoluteString
    }
}

public extension Dictionary where Key == String, Value == String {
    public func append(authorizationHeader: AuthorizationHeader?) -> [String: String] {
        var newHeaders = self
        
        guard let authHeader = authorizationHeader else {
            return self
        }
        
        switch authHeader {
        case .basic(let base64String):
            newHeaders["Authorization"] = "Basic " + (base64String ?? "")
            
        case .bearerToken(let token):
            newHeaders["Authorization"] = "Bearer " + (token ?? "")
        case .custom(let headerKey, let headerValue, let headerValueGenerator):
            newHeaders[headerKey] = headerValueGenerator != nil ? headerValueGenerator!(headerValue) : headerValue
        }
        
        return newHeaders
    }
}

public extension String {
    public func fill(withValues dict: [String: Any?]?) -> String {
        guard let data = dict else {
            return self
        }
        var finalString = self
        data.forEach { arg in
            if let unwrappedValue = arg.value {
                finalString = finalString.replacingOccurrences(of: "{\(arg.key)}", with: String(describing: unwrappedValue))
            }
        }
        return finalString
    }
    
    public func stringByAdding(urlEncodedFields fields: Parameters?) throws -> String {
        guard let f = fields else { return self }
        return try f.urlEncodedString(base: self)
    }
}

extension Data {
    mutating func append(_ string: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw EncodingError.dataIsNotEncodable(string)
        }
        append(data)
    }
}

public extension NSUUID {
    public class func randomBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}

public typealias FormData = [(Data, String, String, String)]
public typealias Parameters = [String: Any?]
public typealias HTTPHeaders = [String: String]
