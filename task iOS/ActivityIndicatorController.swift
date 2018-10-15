//
//  GlobalDataContext.swift
//  task iOS
//
//  Created by petr on 10/15/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

class ActivityIndicatorController: NSObject {
    
    static var instance = ActivityIndicatorController();
    
    @objc dynamic var activityIndicatorCounter: Int = 0
    
    
    func incrementActivityIndicator() {
        self.activityIndicatorCounter += 1;
    }
    
    func decrementActivityIndicator() {
        if self.activityIndicatorCounter > 0 {
            self.activityIndicatorCounter -= 1;
        }
        else {
            ErrorHandler.instance.reportError(withError: TIOSError.ActivityIndicatorCounterError);
        }
    }

}
