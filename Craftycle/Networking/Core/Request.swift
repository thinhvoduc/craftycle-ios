//
//  Request.swift
//  Craftycle
//
//  Created by Thinh Vo on 17/04/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import Foundation

public enum EncodingError: Error {
    case dataIsNotEncodable(_ : Any)
    case invalidURL(_: String)
}

public struct RequestBody {
    
    public enum Encoding {
        case rawData
        case json
        case urlEncoded(_ : String.Encoding?)
        case multipart(_: String) // Boundary string
        case custom(_: CustomEncoder)
        //TODO: JSON
        
        public typealias CustomEncoder = ((Any) -> (Data))
    }
    
    let data: Any
    let encoding: Encoding
    
    private init(_ data: Any, as encoding: Encoding) {
        self.data = data
        self.encoding = encoding
    }
    
    public static func raw(data: Data) -> RequestBody {
        return RequestBody(data, as: .rawData)
    }
    
    public static func json(data: Any) -> RequestBody {
        return RequestBody(data, as: .json)
    }
    
    public static func urlEncoded(_ data: Parameters, encoding: String.Encoding? = .utf8) -> RequestBody {
        return RequestBody(data, as: .urlEncoded(encoding))
    }
    
    public static func multipart(_ data: Multipart) -> RequestBody {
        return RequestBody(data, as: .multipart(NSUUID.randomBoundary()))
    }
    
    public func encodedData() throws -> Data? {
        switch self.encoding {
        case .rawData:
            guard let data = self.data as? Data else {
                throw EncodingError.dataIsNotEncodable(self.data)
            }
            
            return data
            
        case .json:
            return try JSONSerialization.data(withJSONObject: data, options: [])
            return nil
            
        case .urlEncoded(let encoding):
            var encodedString = try (self.data as! Parameters).urlEncodedString()
            encodedString.remove(at: encodedString.startIndex)
            guard let data = encodedString.data(using: encoding ?? .utf8) else {
                throw EncodingError.dataIsNotEncodable(self.data)
            }
            return data
        case .multipart(let boundary):
            let multiPartData = try (data as! Multipart).data(boundary)
            if multiPartData == nil {
                throw EncodingError.dataIsNotEncodable(data)
            }
            return multiPartData
            
        case .custom(let encoder):
            return encoder(data)
        }
    }
    
    public var headers: HTTPHeaders? {
        switch encoding {
        case .multipart(let boundary):
            return ["Content-Type": "multipart/form-data; boundary=\(boundary)"]
        default:
            return nil
        }
    }
}

public protocol Request: NSObjectProtocol {
    
    var method: HTTPMethod { get set }
    
    var endpoint: String { get set }
    
    var queryParams: Parameters? { get set }
    
    var pathParams: Parameters? { get set }
    
    var headers: HTTPHeaders? { get set }
    
    var timeOut: TimeInterval? { get set }
    
    var body: RequestBody? { get set }
    
    var cachePolicy: URLRequest.CachePolicy? { get set }
    
    func headers(in service: Service) -> HTTPHeaders
    
    func url(in service: Service) throws -> URL
    
    func urlRequest(in service: Service) throws -> URLRequest
}

public extension Request {
    
    func headers(in service: Service) -> HTTPHeaders {
        var newHeaders = service.headers
        headers?.forEach({key, value in newHeaders[key] = value})
        
        return newHeaders
    }
    
    func url(in service: Service) throws -> URL {
        let baseURLString = service.configuration.baseURL.appending(endpoint)
        let fullURLString = try baseURLString.fill(withValues: pathParams).stringByAdding(urlEncodedFields: queryParams)
        
        guard let url = URL(string: fullURLString) else {
            // Throw an error
            throw EncodingError.dataIsNotEncodable(fullURLString)
        }
        
        return url
    }
    
    func urlRequest(in service: Service) throws -> URLRequest {
        let requestURL = try url(in: service)
        let cachePolicy = self.cachePolicy ?? service.configuration.cachePolicy
        let timeout = self.timeOut ?? service.configuration.timeout
        var headers = self.headers(in: service)
        
        var urlRequest = URLRequest(url: requestURL, cachePolicy: cachePolicy, timeoutInterval: timeout)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = self.method.rawValue
        
        
        if let bodyData = try body?.encodedData() {
            urlRequest.httpBody = bodyData

        }
        
        if let extraHeaders = body?.headers {
            for (key, value) in extraHeaders {
                headers[key] = value
            }
        }
        
        for (key, value) in headers {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
    
    // Utility method
//    fileprivate func append(_ httpHeaders: HTTPHeaders, to request: URLRequest) -> URLRequest {
//        guard httpHeaders.count > 0 else { return request }
//
//        var newRequest = request
//
//
//
//        return newRequest
//    }
}
