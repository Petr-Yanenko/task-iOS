//
//  EditingUserRequest.swift
//  task iOS
//
//  Created by petr on 10/16/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

class EditingUserRequest: CreatingUserRequest {
    
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
        
        try self.init(
            user: user,
            keyPath: kUserRequestKeyPath + "?user_id=\(user.id)",
            completion: completion
        );
    }
    
}
