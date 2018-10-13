//
//  ListModel.swift
//  task iOS
//
//  Created by petr on 10/13/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

class ListModel<T: NSObject>: BaseModel {
    
    var _list: [T];
    
    
    override init() {
        //First stage of initialization
        _list = [T]();
        
        super.init();
        //Second stage of initialization
    }
    
    func getItem(at index: Int) -> T {
        return _list[index];
    }
    
    func append(item: T) {
        _list.append(item);
    }
    
    func delete(item: T) {
        let index = _list.index { (element: T) -> Bool in
            return item === element;
        };
        if let i = index {
            _list.remove(at: i);
        }
    }
    
    final func copyData(fromPosition index: Int) -> [T] {
        let subarray = _list[index..._list.endIndex];
        return [T](subarray);
    }
    
    final func count() -> Int {
        return _list.count;
    }
    
    override func reset() {
        super.reset();
        _list = [T]();
    }
    
}
