//
// Created by Petr Yanenko on 8/20/16.
// Copyright (c) 2016 Petr Yanenko. All rights reserved.
//

import Foundation

@objc protocol PTableViewModel : PViewModel {
    
    func sectionsNumber() -> Int;
    func cellsNumber(_ section: Int) -> Int;
    func cellReuseIdentifier(_ indexPath: IndexPath?) -> String;
    func rowHeight(_ tableHeight: CGFloat, indexPath: IndexPath?) -> CGFloat;
    func selectRowAction(_ indexPath: IndexPath) -> Void;
    
}

class TableViewModel : BaseViewModel, PTableViewModel {
    
    private var _tableData: [BaseCellViewModel] {
        get {
            return _data as! [BaseCellViewModel];
        }
    }
    

    init(model: BaseModel) {
        super.init(model: model, data: [BaseCellViewModel]());
    }
    
    func cellReuseIdentifier(_ indexPath: IndexPath?) -> String {
        return "";
    }

    func rowHeight() -> CGFloat {
        return self.rowHeight(0);
    }

    func rowHeight(_ tableHeight: CGFloat) -> CGFloat {
        return self.rowHeight(tableHeight, indexPath: nil);
    }

    func rowHeight(_ tableHeight: CGFloat, indexPath: IndexPath?) -> CGFloat {
        return 0;
    }

    func selectRowAction(_ indexPath: IndexPath) {
        self._selectRow(indexPath);
    }

    func cellViewModel(_ indexPath: IndexPath) -> BaseCellViewModel {
        return self._tableData[indexPath.row];
    }

    func sectionsNumber() -> Int {
        return self.cellsNumber(0) > 0 ? 1 : 0;
    }

    func cellsNumber(_ section: Int) -> Int {
        return self._tableData.count;
    }
}

// MARK: protected
@objc extension TableViewModel {
    
    func _selectRow(_ indexPath: IndexPath) {

    }

    func _rowsCount(_ batch: Int) -> Int {
        return 0;
    }

    func _batchesCount() -> Int {
        return 1;
    }

    override func _createViewData() throws -> Any {
        var data = [BaseCellViewModel]();
        for i in 0..<self._rowsCount(0) {
            let item = try self._createItem();
            item.configure(IndexPath(row: i, section: 0));
            data.append(item);
        }
        return data;
    }

    func _createItem() throws -> BaseCellViewModel {
        throw TIOSError.GenericError(nil);
    }

}
