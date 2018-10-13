//
//  URL_Extension.swift
//  task iOS
//
//  Created by petr on 10/11/18.
//  Copyright © 2018 petr. All rights reserved.
//

import Foundation


extension URL {
    static func tios_URLWithRelativeURL(
        string: String,
        relativeTo url: String
        ) throws -> URL {
        let baseURL = URL(string: url);
        let relativeURL = URL(string: string, relativeTo: baseURL);
        
        guard let createdURL = relativeURL else {
            let urlError = TIOSError.RelativeURLError
            throw urlError;
        }
        
        return createdURL;
    }
}
