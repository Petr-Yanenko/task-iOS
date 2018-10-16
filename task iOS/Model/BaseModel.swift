//
//  BaseModel.swift
//  task iOS
//
//  Created by petr on 10/11/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

@objc protocol Model: NSObjectProtocol {
    
    var newData: Bool { get }
    var loading: Bool { get }
    var error: Error? { get }
    
    func loadData();
    func reset();
    func cancel();
    func suspend();
    func resume();
    
}

class BaseModel: NSObject, Model {
    
    dynamic var newData: Bool = false;
    
    dynamic var loading: Bool = false;
    
    dynamic var error: Error?;
    
    weak var _lastRequest: BaseRequest?;
    
    
    deinit {
        self.loading = false;
    }
    
    func loadData() {
        self._startNetworkOperation();
    }
    
    func reset() {
        self.cancel();
    }
    
    func cancel() {
        _lastRequest?.cancel();
    }
    
    func suspend() {
        _lastRequest?.suspend();
    }
    
    func resume() {
        _lastRequest?.resume();
    }
    
}
    
// MARK: Protected
@objc extension BaseModel {
    
    func _startNetworkOperation() {
        self.loading = true;
        self._executeRequest { [weak self] responseObject, error in
            if let sself = self {
                sself._processResponse(responseObject, error);
            }
        };
    }
    
    func _executeRequest(with completion: @escaping (Any?, Error?) -> Void) {
        do {
            self._lastRequest?.cancel();
            let request = try self._request(with: completion);
            request.execute();
            self._lastRequest = request;
        }
        catch {
            completion(false, error);
        }
    }
    
    func _request(with completion: @escaping (Any?, Error?) -> Void) throws -> BaseRequest {
        throw TIOSError.GenericError(nil);
    }
    
    func _setData(_ data: Any) {
        
    }
    
    func _processResponse(_ responseObject: Any?, _ error: Error?) {
        var newData = false;
        if let response = responseObject {
            self._setData(response);
            newData = true;
        }
        self.newData = newData;
        self.error = error;
        self.loading = false;
    }

}
