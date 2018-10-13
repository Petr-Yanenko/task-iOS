//
//  NSOperationQueue_Extension.swift
//  task iOS
//
//  Created by petr on 10/12/18.
//  Copyright © 2018 petr. All rights reserved.
//

import Foundation

extension OperationQueue {
    
    private static weak var tios_previousRequest: BaseRequest? = nil;
    
    static var tios_globalQueue = OperationQueue();
    
    
    func tios_addRequest(_ request: BaseRequest) {
        if let previous = OperationQueue.tios_previousRequest {
            request.addDependency(previous);
        }
        self.addOperation(request);
    }
    
}
