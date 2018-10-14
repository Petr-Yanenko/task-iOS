//
// Created by Petr Yanenko on 8/20/16.
// Copyright (c) 2016 Petr Yanenko. All rights reserved.
//

import Foundation

@objc protocol PCellViewModel : NSObjectProtocol {
    
    init(viewModel: PViewModel, model: BaseModel);
    
    func configure(_ indexPath: IndexPath);
    
}

class BaseCellViewModel : NSObject, PCellViewModel {

    unowned let _viewModel : PViewModel;
    let _model : BaseModel;

    
    class func createCell(viewModel: PViewModel, model: BaseModel) throws -> BaseCellViewModel {
        throw TIOSError.GenericError(nil);
    }
    
    required init(viewModel: PViewModel, model: BaseModel) {
        _viewModel = viewModel;
        _model = model;
        super.init();
    }

    func configure(_ indexPath: IndexPath) -> Void {

    }
}
