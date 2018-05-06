//
//  BaseWebService.swift
//  Craftycle
//
//  Created by Thinh Vo on 18/04/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

typealias WebSerivceErrorBlock = (WebServiceError?) -> Void

class BaseWebService: NSObject, Service{
    var configuration: ServiceConfiguration
    
    var headers: HTTPHeaders
    
    required init(_ serviceConfiguration: ServiceConfiguration) {
        configuration = serviceConfiguration
        headers = configuration.headers
        
        super.init()
    }
    
    func execute(_ request: Request, completionHandler: @escaping ((Response) -> Void)) {
        let request = try! request.urlRequest(in: self)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                let response = BaseResponse(data, response: response, responseError: error)
                completionHandler(response)
            }
        }
        
        task.resume()
    }
    
    // Execute error when there is an error from Response
    func execute(_ failureBlock: WebSerivceErrorBlock?, with response: Response) {
        guard let block = failureBlock else {
            return
        }
        
        var error: WebServiceError?
        
        error = self.error(for: response)
        
        error = error ?? WebServiceError.unknown
        
        block(error)
    }
    
    // Map a Response to a error
    func error(for response: Response) -> WebServiceError? {
        switch response.result {
        case .success(_):
            return nil
        case .error(_):
            if (response.error as NSError?)?.code == NSURLErrorNotConnectedToInternet {
                return WebServiceError.noInternetConnection
            }
            if response.httpStatusCode == 401 {
                return WebServiceError.unauthorized
            }
            
            if response.httpStatusCode == 500 {
                return WebServiceError.serverError
            }
            
            // Error from backend-defined code
            if let data = response.data {
                if let errorMessage = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let codeString = errorMessage?["code"] as? String {
                        if let code = Int(codeString) {
                            return WebServiceError(rawValue: code)
                        }
                    }
                }
            }
            
            return WebServiceError.unknown
        default:
            return nil
        }
    }

}
