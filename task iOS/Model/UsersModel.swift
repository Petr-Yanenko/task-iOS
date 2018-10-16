//
//  UsersModel.swift
//  task iOS
//
//  Created by petr on 10/13/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

class UsersModel: ListModel, CreatingUserModelDelegate {
    
    func copyUsers(fromPosition index: Int) -> [TIOSUserEntityProtocol] {
        let users = self.copyData(fromPosition: index);
        return users as! [TIOSUserEntityProtocol];
    }
    
}
    
// MARK: Protected
extension UsersModel {
    
    override func _request(with completion: @escaping (Any?, Error?) -> Void) throws -> BaseRequest {
        return try UsersRequest() { _, responseObject, error in
            completion(responseObject, error);
        }
    }
    
    override func _setData(_ data: Any) {
        self._list = data as! [TIOSUserEntity];
    }
    
}

// MARK: CreatingUserModelDelegate
extension UsersModel {
    
    func userModel(_ model: CreatingUserModel, didReceiveUsers users: [TIOSUserEntity]?) {
        self._processResponse(users, nil);
    }
    
}
