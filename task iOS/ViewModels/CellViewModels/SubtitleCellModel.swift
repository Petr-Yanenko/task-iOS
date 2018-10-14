//
// Created by Petr Yanenko on 8/20/16.
// Copyright (c) 2016 Petr Yanenko. All rights reserved.
//

import Foundation

class SubtitleCellModel : BaseCellViewModel {

    var _objectID : String = "";
    var objectID : String { get { return _objectID; } }

    var _title : String = "";
    var title : String { get { return _title.trimmingCharacters(in: CharacterSet.newlines); } };

    var _subtitle : String = "";
    var subtitle : String { get { return _subtitle; } }

    var selected : Bool = false;

    var model : ListModel { get { return _model as! ListModel; } }

    override func configure(_ indexPath: IndexPath) -> Void {
        do {
            self._setData(fromObject: try self._dataObject(indexPath));
        }
        catch {
            ErrorHandler.instance.reportError(withError: error);
        }
    }
}

// MARK: protected
@objc extension SubtitleCellModel {
    
    func _dataObject(_ indexPath: IndexPath) throws -> AnyObject {
        throw TIOSError.GenericError(nil);
    }

    func _setData(fromObject object: AnyObject) -> Void {
        
    }

}
