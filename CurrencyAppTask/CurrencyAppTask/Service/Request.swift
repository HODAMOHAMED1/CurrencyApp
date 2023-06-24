//
//  Request.swift
//  GenericNetwork
//
//  Created by hoda mohamed on 24/06/2023.
//

import Foundation
import UIKit

protocol Requestable {
    /**
     Generates a URLRequest from the request. This will be run on a background thread so model parsing is allowed.
     */
    func urlRequest() -> URLRequest
}

/**
 A simple request with no post data.
 */
struct Request: Requestable {
    let path: String
    let queryParameters : [URLQueryItem]?
    func urlRequest() -> URLRequest {
        var urlComps = URLComponents(string: "http://data.fixer.io/api/\(path)")!
        if let parametes = queryParameters{
            if parametes.count > 0{
                let queryItems = parametes
                urlComps.queryItems = queryItems
            }
        }
        let result = urlComps.url!
        var request = URLRequest(url: result)
        request.httpMethod = "GET"
        return request
    }
}

struct PostRequest<Model: Encodable>: Requestable {
    let path: String
    let model: Model
    
    func urlRequest() -> URLRequest {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com") else {
            print("Failed to create base url")
            return URLRequest(url: URL(fileURLWithPath: ""))
        }
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = "POST"
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(model)
            request.httpBody = data
            request.setValue("application/json",
                                forHTTPHeaderField: "Content-Type")
        } catch let error {
            print("Post request model parsing failed")
        }
        return request
    }
}

extension URLRequest: Requestable {
    func urlRequest() -> URLRequest { return self }
}
