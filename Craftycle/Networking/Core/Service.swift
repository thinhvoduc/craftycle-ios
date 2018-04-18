//
//  Service.swift
//  Craftycle
//
//  Created by Thinh Vo on 17/04/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

public protocol Service {
    
    var configuration: ServiceConfiguration { get }
    
    var headers: HTTPHeaders { get }
    
    init(_ configuration: ServiceConfiguration)
    
    func execute(_ request: Request, completionHandler: @escaping ((Response) -> Void))
}
