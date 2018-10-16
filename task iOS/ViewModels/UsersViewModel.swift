//
//  UsersViewModel.swift
//  task iOS
//
//  Created by petr on 10/15/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

class UsersViewModel: TableViewModel {

    var usersModel: UsersModel {
        get {
            return _model as! UsersModel;
        }
    }
    
    init(model: UsersModel) {
        super.init(model: model);
    }
    
    override func cellReuseIdentifier(_ indexPath: IndexPath?) -> String {
        return "UsersCell";
    }
    
}

// MARK: Protected
extension UsersViewModel {
    
    override func _rowsCount(_ batch: Int) -> Int {
        return self.usersModel.count();
    }
    
    override func _createItem() throws -> BaseCellViewModel {
        return UsersCellViewModel(viewModel: self, model: self.usersModel);
    }
    
}
