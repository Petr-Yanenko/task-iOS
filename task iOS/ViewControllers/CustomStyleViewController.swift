//
// Created by Petr Yanenko on 8/25/16.
// Copyright (c) 2016 Petr Yanenko. All rights reserved.
//

import Foundation

class CustomStyleViewController : RefreshableTableViewController {

// MARK: protected
    override func _configureTableView() -> Void {
        super._configureTableView();
        if #available(iOS 9.0, *) {
            _tableView.cellLayoutMarginsFollowReadableWidth = false
        } else {
            // Fallback on earlier versions
        };
    }

    override func _configureCell(_ cell: UITableViewCell, indexPath: IndexPath) -> Void {
        cell.selectionStyle = UITableViewCellSelectionStyle.gray;
        cell.preservesSuperviewLayoutMargins = false;
    }

// MARK: TableView
    func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) -> Void {
        cell.separatorInset = UIEdgeInsets.zero;
        cell.preservesSuperviewLayoutMargins = false;
        cell.layoutMargins = UIEdgeInsets.zero;
    }

}
