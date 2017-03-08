//
//  Request.swift
//  Studentenfutter
//
//  Created by Hans Knöchel on 29.03.16.
//  Copyright © 2016 Hans Knoechel. All rights reserved.
//

import Foundation

@objc protocol RequestDelegate: class {
    @objc optional func didReceiveDummyData(_ request: Request)
    @objc optional func didStartLoadingWithRequest(_ request: Request)
    @objc optional func didFinishLoadingWithRequest(_ request: Request, data: Data?, response: URLResponse?, error: Error?)
}

class Request : NSObject, URLSessionDelegate, RequestDelegate {
    
    weak var delegate: RequestDelegate!
    var config: Config!
    var url: URL!
    
    init(delegate: RequestDelegate) {
        super.init()
        self.delegate = delegate
        self.config = Config()
    }
    
    func load(_ requestURL: String) {
        self.delegate.didStartLoadingWithRequest!(self)
        
        if (config.apiKey() == nil) {
            self.delegate.didReceiveDummyData!(self)
            return;
        }
        
        url = URL(string: requestURL)
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = ["Authorization" : config.apiKey()!]
        
        let session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
        
        let task = session.dataTask(with: url!, completionHandler: {(data, response, error) in
            self.delegate.didFinishLoadingWithRequest!(self, data: data, response: response, error: error)
        })
        task.resume()
    }
}
