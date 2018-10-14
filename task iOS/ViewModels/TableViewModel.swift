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
    
    var _data = [BaseCellViewModel]();


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
        return _data[indexPath.row];
    }

    func sectionsNumber() -> Int {
        return self.cellsNumber(0) > 0 ? 1 : 0;
    }

    func cellsNumber(_ section: Int) -> Int {
        return _data.count;
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
            let item = try self._initializeItem();
            item.configure(IndexPath(row: i, section: 0));
            data.append(item);
        }
        return data;
    }
    
    override func _setData(_ data: Any) {
        self._data = data as! [BaseCellViewModel];
        super._setData(data);
    }

    func _initializeItem() throws -> BaseCellViewModel {
        let item = try BaseCellViewModel.createCell(viewModel: self, model: _model);
        return item;
    }

}
