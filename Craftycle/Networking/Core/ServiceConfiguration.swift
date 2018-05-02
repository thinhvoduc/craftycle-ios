//
//  ServiceConfiguration.swift
//  Craftycle
//
//  Created by Thinh Vo on 17/04/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

public struct Multipart {
    let formData: FormData?
    let parameters: Parameters?
    
    public init(formData data: FormData, parameters: Parameters?) {
        self.formData = data
        self.parameters = parameters
    }
}

public extension Multipart {
    public func data(_ boundary: String) throws -> Data? {
        
        let paramsCount = parameters?.count ?? 0
        let formDataCount = formData?.count ?? 0
        
        guard paramsCount > 0 || formDataCount > 0 else {
            return nil
        }
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                if let value = value {
                    try body.append("--\(boundary + lineBreak)")
                    try body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                    try body.append("\(String(describing: value) + lineBreak)")
                }
            }
        }
        
        if let media = formData {
            for aFormData in media {
                let data = aFormData.0
                let dataKey = aFormData.1
                let fileName = aFormData.2
                let mimeType = aFormData.3
                try body.append("--\(boundary + lineBreak)")
                try body.append("Content-Disposition: form-data; name=\"\(dataKey)\"; filename=\"\(fileName)\"\(lineBreak)")
                try body.append("Content-Type: \(mimeType + lineBreak + lineBreak)")
                body.append(data)
                try body.append(lineBreak)
            }
        }
        
        try body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public final class ServiceConfiguration: NSObject {
    
    private(set) var name: String = ""
    
    private(set) var baseURL: String
    
    private(set) var url: URL
    
    private(set) var headers: HTTPHeaders = [:]
    
    public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    
    public var timeout: TimeInterval = 15.0
    
    public init?(serviceName: String? = nil, baseURL urlString: String) {
        guard let baseUrl = URL(string: urlString) else { return nil }
        
        url = baseUrl
        baseURL = urlString
        super.init()
        
        name = serviceName ?? (url.host ?? "")
    }
    
    public static func defaultAppConfiguration() -> ServiceConfiguration? {
        return ServiceConfiguration()
    }
    
    public convenience init?(configurationFile fileName: String? = nil) {
        if fileName != nil {
            // TODO: Implement the parsing here
            fatalError("Implement here")
            return nil
        }
        
        guard let endpoint = Bundle.main.object(forInfoDictionaryKey: "Endpoint") as? Dictionary<String, Any>,
              let baseUrl = endpoint["Base"] as? String, let name = endpoint["Name"] as? String else { return nil }
        
        // NOTE: Have no idea why the url
        self.init(serviceName: name, baseURL: baseUrl)
    }
}
