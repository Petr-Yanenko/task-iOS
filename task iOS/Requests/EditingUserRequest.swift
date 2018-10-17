//
//  EditingUserRequest.swift
//  task iOS
//
//  Created by petr on 10/16/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

class EditingUserRequest: CreatingUserRequest {
    
    private var _userID = 0;
    
    
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
            keyPath: "edit_user.php",
            completion: completion
        );
        
        _userID = user.id;
    }
    
}

// MARK: Protected
extension EditingUserRequest {
    
    override func _request() throws -> URLRequest {
        do {
            var request = try super._request();
            let query = AFQueryStringFromParameters(["user_id": self._userID]);
            guard let url = request.url?.absoluteString else {
                throw TIOSError.GenericError(nil);
            }
            request.url = URL(string: url + "?\(query)");
            return request;
        }
        catch {
            throw TIOSError.EditingUserRequestError(error);
        }
    }
    
}
