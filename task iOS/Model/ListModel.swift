//
//  ListModel.swift
//  task iOS
//
//  Created by petr on 10/13/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

class ListModel: BaseModel {
    
    var _list: [AnyObject];
    
    
    override init() {
        //First stage of initialization
        _list = [AnyObject]();
        
        super.init();
        //Second stage of initialization
    }
    
    func getItem(at index: Int) -> AnyObject {
        return _list[index];
    }
    
    func append(item: AnyObject) {
        _list.append(item);
    }
    
    func delete(item: AnyObject) {
        let index = _list.index { (element: AnyObject) -> Bool in
            return item === element;
        };
        if let i = index {
            _list.remove(at: i);
        }
    }
    
    final func copyData(fromPosition index: Int) -> [AnyObject] {
        let subarray = _list[index..._list.endIndex];
        return [AnyObject](subarray);
    }
    
    final func count() -> Int {
        return _list.count;
    }
    
    override func reset() {
        super.reset();
        _list = [AnyObject]();
    }
    
}
