//
//  RequestUtitlity.swift
//  task iOS
//
//  Created by petr on 10/16/18.
//  Copyright © 2018 petr. All rights reserved.
//

import Foundation

func _requestUtitlityMapUsersResponse(
    _ responseObject: Any,
    _ completion: (Any?, Error?) -> Void
    ) {
    
    // ToDo: Objc library does not use __autorelease specifier at error argument. I believe it is needed to use UnsafePointer instead operator '&' to replace deprecated API. But I am not familar with UnsafePointer to spend much time to fix that.
    let users = TIOSUserEntity.arrayOfModels(
        fromDictionaries: responseObject as? [Any]
    );
    var error: Error?;
    if users == nil {
        error = TIOSError.UsersMappingError;
    }
    completion(users, error);
}
