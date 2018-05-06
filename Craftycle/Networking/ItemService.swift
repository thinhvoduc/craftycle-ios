//
//  ItemService.swift
//  Craftycle
//
//  Created by Thinh Vo on 27/04/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import Foundation

class ItemService: BaseWebService {
    enum Endpoint: String {
        case  allItems = "items"
    }
    
    // Create item
    func createItem(_ image: UIImage, categoryId: Int, isCrafted: Bool, successBlock: ((Item?)->Void)?, failureBlock:WebSerivceErrorBlock?) {
        if let data = UIImagePNGRepresentation(image) {
            let formData: FormData = [(data, "file", "file.png", "image/png")]
            let isCraftedValue = isCrafted ? 1 : 0
            let multipart = Multipart(formData: formData, parameters: ["category_id": categoryId, "crafted": isCraftedValue])
            let body = RequestBody.multipart(multipart)
            let request = BaseRequest(httpMethod: .post, endpointString: Endpoint.allItems.rawValue, queryParameters: nil, pathParameters: nil , requestBody: body)
            execute(request) { (response) in
                switch response.result {
                case .success(_):
                    var item: Item?
                    if let data = response.data {
                        if let fetchedItem = try? JSONDecoder().decode(Item.self, from: data) {
                            item = fetchedItem
                        }
                    }
                    
                    successBlock?(item)
                    
                case .error(_):
                    self.execute(failureBlock, with: response)
                case .noResponse:
                    self.execute(failureBlock, with: response)
                }
                
            }
        }
    }
    
    // Get all items
    func getAllItems(successBlock:(([Item]) -> Void)?, failureBlock:WebSerivceErrorBlock?) {
        let request = BaseRequest(httpMethod: .get, endpointString: Endpoint.allItems.rawValue, queryParameters: nil, pathParameters: nil, requestBody: nil)
        
        execute(request) { response in
            switch response.result {
            case .success(_):
                var items: [Item] = []
                if let data = response.data {
                    if let allItems = try? JSONDecoder().decode([Item].self, from: data) {
                        items = allItems
                    }
                }
                
                // Call the success block
                successBlock?(items)
            case .error(_):
                self.execute(failureBlock, with: response)
            case .noResponse:
                self.execute(failureBlock, with: response)
            }
        }
    }
    
}
