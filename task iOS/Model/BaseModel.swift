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
    
}

class BaseModel: NSObject, Model {
    
    dynamic var newData: Bool = false;
    
    dynamic var loading: Bool = false;
    
    dynamic var error: Error?;
    
    
    weak var _lastRequest: BaseRequest?;
    
    
    func loadData() {
        self.loading = true;
        self._load { [weak self] newData, error in
            if let sself = self {
                sself.newData = newData;
                sself.error = error;
                sself.loading = false;
            }
        };
    }
    
    func reset() {
        self.cancel();
    }
    
    func cancel() {
        _lastRequest?.cancel();
    }
}
    
// MARK: Protected
@objc extension BaseModel {
    
    func _load(with completion: @escaping (Bool, Error?) -> Void) {
        do {
            let request = try self._request(with: completion);
            request.execute();
            self._lastRequest = request;
        }
        catch {
            completion(false, error);
        }
    }
    
    func _request(with completion: @escaping (Bool, Error?) -> Void) throws -> BaseRequest {
        throw TIOSError.GenericError(nil);
    }

}
