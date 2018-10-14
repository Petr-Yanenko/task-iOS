//
//  UsersModel.swift
//  task iOS
//
//  Created by petr on 10/13/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

class UsersModel: ListModel {
    
    func copyUsers(fromPosition index: Int) -> [TIOSUserEntityProtocol] {
        let users = self.copyData(fromPosition: index);
        return users as! [TIOSUserEntityProtocol];
    }
    
}
    
// MARK: Protected
extension UsersModel {
    
    override func _request(with completion: @escaping (Bool, Error?) -> Void) throws -> BaseRequest {
        return try UsersRequest() { [weak self] _, responseObject, error in
            var newData = false;
            if let sself = self {
                if let response = responseObject {
                    sself._list = response;
                    newData = true;
                }
            }
            completion(newData, error);
        }
    }
    
}
