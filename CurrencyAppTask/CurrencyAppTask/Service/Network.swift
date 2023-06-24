//
//  Network.swift
//  GenericNetwork
//
//  Created by hoda mohamed on 24/06/2023.
//

import UIKit
class Network: NSObject {
    
    enum NetworkError: Error {
        case noDataOrError
    }

    static let shared = Network()
    let session: URLSession = URLSession(configuration: .default)

    func send<T: Model>(_ request: Requestable,
              completion: @escaping (Result<T, Error>)->Void) {
        let urlRequest = request.urlRequest()
        print("urlRequest\(urlRequest)")
        let task = session.dataTask(with: urlRequest, completionHandler: {data,response, error in
            let result: Result<T, Error>
            if let error = error {
                result = .failure(error)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    result = .success(try decoder.decode(T.self, from: data))
                } catch {
                    result = .failure(error)
                }
            } else {
                print("Missing both data and error from NSURLSession.")
                result = .failure(NetworkError.noDataOrError)
            }
            DispatchQueue.main.async {
                completion(result)
            }
        })
        task.resume()
    }
}
