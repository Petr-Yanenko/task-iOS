//
//  CreatingUserViewModel.swift
//  task iOS
//
//  Created by petr on 10/15/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

private var _savingUserContext: UInt8 = 0;

class CreatingUserViewModel: TableViewModel {
    
    private var _userModel: CreatingUserModel {
        get {
            return self._model as! CreatingUserModel;
        }
    }
    
    @objc dynamic var userSaved: Bool = false;
    

    deinit {
        self.sna_unregisterAsObserver(
            withSubject: _userModel,
            property: #selector(getter: CreatingUserModel.userSaved),
            context: &_savingUserContext
        );
    }
    
    init(model: CreatingUserModel) {
        super.init(model: model);
    }
    
    override func cellReuseIdentifier(_ indexPath: IndexPath?) -> String {
        return "UserCell";
    }
    
    func save() {
        self._userModel.save();
    }
    
}

// MARK: Protected
extension CreatingUserViewModel {
    
    override func _rowsCount(_ batch: Int) -> Int {
        return 1;
    }
    
    override func _createItem() throws -> BaseCellViewModel {
        return CreatingUserCellViewModel(userViewModel: self, model: self._userModel);
    }
    
    override func _addObservers(_ model: BaseModel) {
        super._addObservers(model);
        self.sna_registerAsObserver(
            withSubject:_userModel,
            property:#selector(getter: CreatingUserModel.userSaved),
            context:&_savingUserContext
        ) { [weak self] _,_,_ in
            if let sself = self {
                sself.userSaved = sself._userModel.userSaved;
            }
        }
    }
    
}
