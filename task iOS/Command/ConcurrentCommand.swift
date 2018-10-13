//
//  ConcurrentCommand.swift
//  task iOS
//
//  Created by petr on 10/12/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

class ConcurrentCommand: Command {
    
    private var _executing = false;
    private var _finished = false;
    
    
    override var isExecuting: Bool {
        get {
            return _executing;
        }
        set {
            if _executing != newValue {
                let key = NSStringFromSelector(#selector(getter: isExecuting));
                self.willChangeValue(forKey: key);
                if (newValue) {
                    self.main();
                }
                _executing = newValue;
                self.didChangeValue(forKey: key);
            }
        }
    }
    
    override var isFinished: Bool {
        get {
            return _finished;
        }
        set {
            if _finished != newValue {
                let key = NSStringFromSelector(#selector(getter: isFinished));
                self.willChangeValue(forKey: key);
                if newValue {
                    self.isExecuting = false;
                }
                _finished = newValue;
                self.didChangeValue(forKey: key);
            }
        }
    }
    
    override var isAsynchronous: Bool {
        get {
            return true;
        }
    }
    
    override func start() {
        if self.isCancelled {
            self.isFinished = true;
        }
        else {
            self.isExecuting = true;
        }
    }

}
