//
//  HTTPManager.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 25..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

struct URLMain {
    static let SearchURL = "https://itunes.apple.com/search"
    static let LookupURL = "https://itunes.apple.com/lookup"
}

enum URLResponseStatusError: Error {
    case statusError(status: Int)
}

enum HTTPMethod {
    case GET
    case POST
}

public typealias HTTPParameters = [String: Any]

class HTTPManager {
    
    private var sessionConfiguration: URLSessionConfiguration?
    private var session: URLSession?
    private let requestCachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy
    private let timeoutInterval: TimeInterval = 60.0
    
    static let shared = HTTPManager()
    
    typealias SuccessHandler = (_ data: Data) -> Void
    typealias FailureHandler = (_ error: Error) -> Void
    
    init() {
        sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration?.requestCachePolicy = requestCachePolicy
        
        session = URLSession(configuration: sessionConfiguration!, delegate: nil, delegateQueue: nil)
    }
    
    func requestJSON(_ url: URL?, httpMethod: HTTPMethod, parameters: HTTPParameters,  _ success: @escaping SuccessHandler, _ failure: @escaping FailureHandler) {
        guard let url = url else {
            return
        }
        
        var urlRequest = URLRequest(url: url, cachePolicy: requestCachePolicy, timeoutInterval: timeoutInterval)
        
        switch httpMethod {
        case .GET:
            urlRequest.httpMethod = "GET"
            
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
                urlComponents.percentEncodedQuery = percentEncodedQuery
                urlRequest.url = urlComponents.url
            }
            break
        case .POST:
            urlRequest.httpMethod = "POST"
            
            do {
                let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
                urlRequest.httpBody = data
            } catch let error as NSError {
                fatalError("Parameters JSON Style make error: \(error)")
            }
            break
        }
        
        DDLogDebug("== Request URL: \(String(describing: urlRequest.url?.absoluteString ?? ""))")
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        self.applicationNetworkActivityIndicatorVisible(true)
        
        let task = session?.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            self.applicationNetworkActivityIndicatorVisible(false)
            
            guard error == nil else {
                DispatchQueue.main.async {
                    failure(error!)
                }
                return
            }
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            guard 200..<300 ~= statusCode else {
                let error = URLResponseStatusError.statusError(status: statusCode)
                DispatchQueue.main.async {
                    failure(error)
                }
                return
            }
            
            guard let data = data else {
                return
            }
            
            //do {
            //    let jsonResponse = try JSONSerialization.jsonObject(with:data, options: [])
            //    DDLogDebug("Response result JSON success: \(jsonResponse)")
            //} catch let error as NSError {
            //    DDLogDebug("Response result error: \(error)")
            //}
            
            DispatchQueue.main.async {
                success(data)
            }
            
            return
        })
        
        task?.resume()
    }
    
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape(value.boolValue ? "1" : "0")))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape(bool ? "1" : "0")))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex
                
                let substring = string[range]
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? String(substring)
                
                index = endIndex
            }
        }
        
        return escaped
    }
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    private func applicationNetworkActivityIndicatorVisible(_ visible: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = visible
        }
    }
    
}
