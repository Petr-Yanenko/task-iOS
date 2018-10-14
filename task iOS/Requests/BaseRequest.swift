//
//  BaseRequest.swift
//  task iOS
//
//  Created by petr on 10/11/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit
import JSONModel
import AFNetworking


typealias RequestCompletion = (
    _ request: BaseRequest,
    _ response: Any?,
    _ error: Error?
    ) -> Void;


protocol Request: NSObjectProtocol {
    
    var method: String { get };
    var params: [String: String] { get };
    var keyPath: String { get };
    
    init(
        object: AbstractJSONModelProtocol?,
        method: String,
        params: [String: String],
        keyPath: String,
        completion: RequestCompletion?
    ) throws;
}


class BaseRequest: ConcurrentCommand, Request, URLSessionDataDelegate {
    
    private weak var _dataTask: URLSessionDataTask?;
    weak var dataTask: URLSessionDataTask? { get { return _dataTask; } };
    
    private var _method: String;
    var method: String { get { return _method; } };
    
    private var _params: [String: String];
    var params: [String: String] { get { return _params; } };
    
    private var _keyPath: String;
    var keyPath: String { get { return _keyPath; } };
    
    private var _response: Any?;
    private var _error: Error?;
    
    private static var _instance: URLSession? = nil;
    
    
    required init(
        object: AbstractJSONModelProtocol?,
        method: String,
        params: [String: String],
        keyPath: String,
        completion: RequestCompletion?
        ) throws {
        
        //First stage of initializtion
        _method = method;
        _keyPath = keyPath;
        
        _params = params;
        
        if let jsonObject = object {
            var json = jsonObject.toDictionary();
            json = json?.merging(params, uniquingKeysWith: { ( _, new) -> Any in
                new
            });
            if let combinedParams = json as? [String: String] {
                _params = combinedParams;
            }
            else {
                throw TIOSError.RequestInitError;
            }
        }
        
        super.init();
        
        //Second stage of initialization
        if let block = completion {
            self.completionBlock = {
                [weak self] in
                if let sself = self {
                    var error: Error?;
                    var response: Any?
                    
                    if (!sself.isCancelled) {
                        error = sself._error;
                        response = sself._response;
                    }
                    DispatchQueue.main.async {
                        block(sself, response, error);
                    }
                }
            }
        }
    }
    
    convenience init(
        method: String,
        params: [String: String],
        keyPath: String,
        completion: RequestCompletion?
        ) throws {
        
        try self.init(
            object: nil,
            method: method,
            params: params,
            keyPath: keyPath,
            completion: completion
        );
    }
    
    convenience init(
        method: String,
        keyPath: String,
        completion: RequestCompletion?
        ) throws {
        
        try self.init(
            method: method,
            params: [String: String](),
            keyPath: keyPath,
            completion: completion
        );
    }
    
    override func execute() {
        OperationQueue.tios_globalQueue.tios_addRequest(self);
    }
    
    override func cancel() {
        super.cancel();
        
        self.dataTask?.cancel();
    }
}
    
// MARK: Protected
@objc extension BaseRequest {
    
    override func _performTask() {
        do {
            let request = try self._request();
            self._configureRequest(request);
            let session = self._createSession();
            let task = self._dataTask(withSession: session, request: request);
            self._dataTask = task;
            task.resume();
        }
        catch {
            self._setResponse(nil, error);
        }
    }
    
    func _request() throws -> URLRequest {
        
        guard let keyPath: String = self.keyPath.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.alphanumerics
        )
        else {
            throw TIOSError.URLRequestError(TIOSError.PercentEncodingError);
        }
        
        let urlOrNil: URL?;
        do {
            urlOrNil = try URL.tios_URLWithRelativeURL(
                string: keyPath, relativeTo: kBaseURLString
            )
        }
        catch {
            throw TIOSError.URLRequestError(error);
        }
        
        guard let url: URL = urlOrNil else {
            throw TIOSError.URLRequestError(TIOSError.GenericError(nil));
        }
        
        var error: NSError?
        let request = AFHTTPRequestSerializer().request(
            withMethod: self.method,
            urlString: url.absoluteString,
            parameters: self.params,
            error: &error
        );
        
        if let unwrappedError = error {
            throw TIOSError.URLRequestError(unwrappedError);
        }
        
        return request as URLRequest;
    }
    
    func _configureRequest(_ request: URLRequest) {
    }
    
    func _createSession() -> URLSession {
        
        if BaseRequest._instance == nil {
            let configuration = URLSessionConfiguration.default;
            BaseRequest._instance = URLSession(
                configuration: configuration,
                delegate: self,
                delegateQueue: nil
            );
        }
        return BaseRequest._instance!;
    }
    
    func _dataTask(
        withSession session: URLSession,
        request: URLRequest
        ) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                self._setResponse(nil, TIOSError.InvalidResponseError(error));
                return;
            }
            
            func mappingCompletion(responseObject: Any?, error: Error?)  {
                self._checkOnCancel {
                    self._processResponse(
                        httpResponse,
                        responseObject,
                        error
                    );
                }
            }
            
            self._checkOnCancel {
                self._createResponseObject(
                    withResponse: httpResponse,
                    data: data,
                    completion: mappingCompletion
                );
            }
        }
        
        return task;
    }
    
    final func _checkOnCancel(withProceedingBlock block: () -> Void) {
        if !self.isCancelled {
            block();
        }
        else {
            self.isFinished = true;
        }
    }
    
    func _setResponse(_ response: Any?,_ error: Error?) {
        self._response = response;
        self._error = error;
        self.isFinished = true;
    }
    
    func _mapResponse(
        _ responseObject: Any,
        _ completion: (Any?, Error?) -> Void
        ) {
        
        completion(nil, nil);
    }
    
    func _createResponseObject(
        withResponse response: HTTPURLResponse,
        data: Data?,
        completion: @escaping (Any?, Error?) -> Void
        ) {
        self._checkOnCancel {
            var responseObject: Any?;
            var jsonError: Error?;
            
            if let unwrappedData = data {
                do {
                    responseObject = try JSONSerialization.jsonObject(
                        with: unwrappedData, options: JSONSerialization.ReadingOptions(rawValue: 0)
                    );
                }
                catch {
                    jsonError = TIOSError.JSONError(error);
                }
            }
            
            if self._isSuccessfulResponse(response) {
                if let unwrappedResponseObject = responseObject {
                    self._checkOnCancel {
                        self._mapResponse(unwrappedResponseObject, completion);
                    }
                }
            }
            
            if self._isFailedResponse(response) || responseObject == nil {
                completion(responseObject, jsonError);
            }
        }
    }
    
    func _processResponse(
        _ response: HTTPURLResponse,
        _ responseObject: Any?,
        _ error: Error?
        ) {
        if self._isFailedResponse(response) {
            let httpError: Error = TIOSError.HTTPError(response.statusCode, responseObject ?? error);
            self._setResponse(nil, httpError);
        }
        else if self._isSuccessfulResponse(response) {
            self._setResponse(responseObject, error);
        }
    }
    
    func _isSuccessfulResponse(_ response: HTTPURLResponse) -> Bool {
        return response.statusCode >= 200 && response.statusCode < 300;
    }
    
    func _isFailedResponse(_ response: HTTPURLResponse) -> Bool {
        return response.statusCode >= 400 && response.statusCode < 600;
    }
}
    
// MARK: URLSessionDataDelegate
extension BaseRequest {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self._checkOnCancel {}
    }
    
}
