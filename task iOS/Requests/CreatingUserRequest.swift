//
//  CreatingUserRequest.swift
//  task iOS
//
//  Created by petr on 10/15/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

class CreatingUserRequest: BaseRequest {
    
    required init(
        object: AbstractJSONModelProtocol?,
        method: String,
        params: [String : Any],
        keyPath: String,
        completion: RequestCompletion?
        ) throws {
        
        try super.init(
            object: object,
            method: method,
            params: params,
            keyPath: keyPath,
            completion: completion
        );
    }
    
    convenience init(
        user: TIOSUserEntity,
        completion: @escaping (CreatingUserRequest, [TIOSUserEntity]?, Error?) -> Void
        ) throws {
        
        try self.init(object: nil, method: "POST", params: ["User": user.toDictionary()], keyPath: "users.php") { (request, responseObject, error) in
            let userRequest = request as! CreatingUserRequest;
            let users = responseObject as? [TIOSUserEntity];
            completion(userRequest, users, error);
        }
    }
    
    override func _mapResponse(
        _ responseObject: Any,
        _ completion: (Any?, Error?) -> Void
        ) {
        
        _requestUtitlityMapUsersResponse(responseObject, completion);
    }

}
