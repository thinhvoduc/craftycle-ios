//
//  NetworkingTest.swift
//  NetworkingTest
//
//  Created by Thinh Vo on 06/05/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import XCTest
@testable import Craftycle

class NetworkingTest: XCTestCase {
    
    var baseURL: String!
    var configuration: ServiceConfiguration!
    var service: BaseWebService!
    override func setUp() {
        super.setUp()
        baseURL =  "https://abcdefgh.unkown"
        configuration = ServiceConfiguration(baseURL: baseURL)!
        service = BaseWebService(configuration)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testInvalidServiceConfiguration() {
        let baseURL = "google..com123#€"
        let configuration = ServiceConfiguration(baseURL: baseURL)
        
        XCTAssertNil(configuration)
    }
    
    func testValidServiceConfiguration() {
        let baseURL = "http://routemenow.eu/api"
        let configuration = ServiceConfiguration(baseURL: baseURL)
        
        XCTAssertNotNil(configuration)
    }
    
    func testValidInitilizationRequestURL() {
        let baseURL = "abcd.fake/"
        let configuration = ServiceConfiguration(baseURL: baseURL)
        
        XCTAssertNotNil(configuration)
        let service = BaseWebService(configuration!)
        
        let request = BaseRequest(httpMethod: .get, endpointString: "items", queryParameters: nil, pathParameters: nil, requestBody: nil)
        
        do {
            let urlString = try request.url(in: service).absoluteString
            
            XCTAssertEqual("abcd.fake/items", urlString)
            
        } catch {
            fatalError("Failed to create url from service and request")
        }
    }
    
    func testErrorCode() {
        let promise = expectation(description: "Status code is not 200")
        let request = BaseRequest(httpMethod: .get, endpointString: "/adfasjdfkh", queryParameters: nil, pathParameters: nil, requestBody: nil)
        service.execute(request) { (response) in
            let result = response.result
            
            switch result {
            case .error(let statusCode):
                if 200 == statusCode {
                    XCTFail("Status Code: \(statusCode)")
                } else {
                    promise.fulfill()
                }
            default:
                XCTFail("Must be an error")
            }
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
    }
    
   
    
}
