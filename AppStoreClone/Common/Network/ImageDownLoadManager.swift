//
//  ImageDownLoadManager.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 26..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

class ImageDownLoadManager {
    
    private var operationQueue: OperationQueue?
    private var sessionConfiguration: URLSessionConfiguration?
    private var imageSession: URLSession?
    private let urlCache = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "ImageDownloadCache")
    private let requestCachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy
    private let timeoutInterval: TimeInterval = 60.0
    
    typealias SuccessHandler = (_ image: UIImage) -> Void
    typealias FailureHandler = (_ error: Error) -> Void
    
    static let shared = ImageDownLoadManager()
    
    init() {
        operationQueue = OperationQueue()
        operationQueue?.maxConcurrentOperationCount = 3
        operationQueue?.name = "ImageDownload Operation"
        
        sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration?.requestCachePolicy = requestCachePolicy
        sessionConfiguration?.urlCache = urlCache
        
        imageSession = URLSession(configuration: sessionConfiguration!, delegate: nil, delegateQueue: operationQueue!)
    }
    
    /**
     통신 캐쉬 이미지 요청 함수
     - parameters:
     - url: URL
     - success: 성공 block
     - failure: 실패 block
     */
    func requestImageURL(_ url: URL?, _ success: @escaping SuccessHandler, _ failure: @escaping FailureHandler) {
        guard let url = url else {
            return
        }
        
        let urlRequest = URLRequest(url: url, cachePolicy: requestCachePolicy, timeoutInterval: timeoutInterval)
        
        if let cacheResponse = urlCache.cachedResponse(for: urlRequest) {
            if let cachedImage = UIImage.init(data: cacheResponse.data) {
                DDLogDebug("== Exist cachedImage!!")
                DispatchQueue.main.async {
                    success(cachedImage)
                }
                return
            }
        }
        
        let task = imageSession?.dataTask(with: url, completionHandler: { (data, response, error) in
            DDLogDebug("== Downloading Image!!")
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
            
            if let data = data, let response = response {
                let cacheResponse = CachedURLResponse(response: response, data: data)
                self.urlCache.storeCachedResponse(cacheResponse, for: urlRequest)
                
                DispatchQueue.main.async {
                    if let image = UIImage.init(data: data) {
                        success(image)
                    }
                }
            }
            return
        })
        
        task?.resume()
    }
    
    /**
     캐쉬 이미지 전체 삭제
     */
    func clearCacheAll() {
        urlCache.removeAllCachedResponses()
        URLCache.shared.removeAllCachedResponses()
    }
    
    /**
     url로 캐쉬 이미지를 삭제
     */
    func removeCacheUrl(_ url: URL?) {
        guard let url = url else {
            return
        }
        
        //
        // Note.. not working :(
        // https://ask.helplib.com/ios/post_12303609
        // http://blog.airsource.co.uk/2014/10/13/nsurlcache-ios8-broken-2/
        //
        
        let urlRequest = URLRequest(url: url, cachePolicy: requestCachePolicy, timeoutInterval: timeoutInterval)
        
        urlCache.removeCachedResponse(for: urlRequest)
        URLCache.shared.removeCachedResponse(for: urlRequest)
    }
    
}

