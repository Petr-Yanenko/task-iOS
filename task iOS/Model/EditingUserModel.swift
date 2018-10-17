//
//  EditingUserModel.swift
//  task iOS
//
//  Created by petr on 10/16/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

class EditingUserModel: CreatingUserModel {
    
    private var _initialUser: TIOSUserEntity;
    
    
    init(user: TIOSUserEntity) {
        _initialUser = user;
        super.init();
        
        self._resetUser();
    }
    
    override func reset() {
        super.reset();
        self._resetUser();
    }
    
}

// MARK: Protected
extension EditingUserModel {
    
    override func _request(with completion: @escaping (Any?, Error?) -> Void) throws -> BaseRequest {
        return try EditingUserRequest(user: self._user) { _, responseObject, error in
            completion(responseObject, error);
        }
    }
    
    func _resetUser() {
        self._user.id = self._initialUser.id;
        self._user.firstName = self._initialUser.firstName;
        self._user.lastName = self._initialUser.lastName;
        self._user.email = self._initialUser.email;
        self._user.imageUrl = self._initialUser.imageUrl;
    }

}
