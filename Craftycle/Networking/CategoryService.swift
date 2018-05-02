//
//  CategoryService.swift
//  Craftycle
//
//  Created by Thinh Vo on 18/04/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

class CategoryService: BaseWebService {
    private enum Endpoint: String {
        case allCategories = "categories"
    }
    
    func createCategory(_ image: UIImage, name: String, successBlock: ((Category?)->Void)?, failureBlock:WebSerivceErrorBlock?) {
        if let data = UIImagePNGRepresentation(image) {
            let formData: FormData = [(data, "file", "file.png", "image/png")]
            let multipart = Multipart(formData: formData, parameters: ["category_name": name])
            let body = RequestBody.multipart(multipart)
            let request = BaseRequest(httpMethod: .post, endpointString: Endpoint.allCategories.rawValue, queryParameters: nil, pathParameters: nil , requestBody: body)
            execute(request) { (response) in
                switch response.result {
                case .success(_):
                    var category: Category?
                    if let data = response.data {
                        if let fetchedCategory = try? JSONDecoder().decode(Category.self, from: data) {
                            category = fetchedCategory
                        }
                    }
                    
                    successBlock?(category)
                    
                case .error(_):
                    self.execute(failureBlock, with: response)
                case .noResponse:
                    self.execute(failureBlock, with: response)
                }
                
            }
        }
       
    }
    
    func getAllCategories(successBlock:(([Category]) -> Void)?, failureBlock:WebSerivceErrorBlock?) {
        let request = BaseRequest(httpMethod: .get, endpointString: Endpoint.allCategories.rawValue, queryParameters: nil, pathParameters: nil, requestBody: nil)
        
        execute(request) { response in
            switch response.result {
            case .success(_):
                var categories: [Category] = []
                if let data = response.data {
                    if let allCategories = try? JSONDecoder().decode([Category].self, from: data) {
                        categories = allCategories
                    }
                }
                
                // Call the success block
                successBlock?(categories)
            case .error(_):
                self.execute(failureBlock, with: response)
            case .noResponse:
                self.execute(failureBlock, with: response)
            }
        }
    }
}
