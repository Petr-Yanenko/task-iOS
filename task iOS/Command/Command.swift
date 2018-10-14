//
//  Command.swift
//  task iOS
//
//  Created by petr on 10/11/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

class Command: Operation {
    
    func execute() {
        OperationQueue.tios_globalQueue.addOperation(self);
    }
    
    override func main() {
        do {
            try TIOSExceptionHandler.instance().handleExceptions {
                self._performTask();
            };
        }
        catch let error as NSError {
            ErrorHandler.instance.reportError(withError:TIOSError.TaskException(error))
        }
    }
}

// MARK: Protected
@objc extension Command {
    
    func _performTask() {
        
    }
    
}
