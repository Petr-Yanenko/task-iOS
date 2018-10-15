//
//  ErrorHandler.swift
//  task iOS
//
//  Created by petr on 10/12/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit
import Crashlytics

class ErrorHandler: NSObject {
    
    static let instance = ErrorHandler();
    
    
    func reportError(withError error: Error) {
        let description = (error as? TIOSError)?.localizedFailureReason ?? error.localizedDescription;
        let nserror = NSError(
            domain: "Task_iOS",
            code: 0,
            userInfo: [
                NSLocalizedFailureReasonErrorKey: description
            ]
        );
        self.reportError(withNSError: nserror);
    }
    
    func reportError(withNSError error: NSError) {
        Crashlytics.sharedInstance().recordError(error);
    }

}
