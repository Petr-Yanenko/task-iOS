//
//  ClosureCommand.swift
//  task iOS
//
//  Created by petr on 10/12/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit


typealias Task = () -> Void


class ClosureCommand: Command {
    
    private var _closure: Task;
    var closure: Task { get { return _closure; } };
    
    
    init(closure: @escaping Task) {
        //First stage of initialization
        _closure = closure;
        
        super.init()
        
        //Second stage of initialization
    }
    
    static func execute(closure: @escaping Task) -> ClosureCommand {
        let command = ClosureCommand(closure: closure);
        command.execute();
        return command;
    }
}
    
// MARK: Protected
extension ClosureCommand {
    
    override func _performTask() {
        self.closure();
    }
    
}
