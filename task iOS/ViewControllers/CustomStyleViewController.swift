//
// Created by Petr Yanenko on 8/25/16.
// Copyright (c) 2016 Petr Yanenko. All rights reserved.
//

import Foundation

private var _keyboardContext: UInt8 = 0;

class CustomStyleViewController : RefreshableTableViewController {
    
//    MARK: Life cycle
    deinit {
        self.sna_unregisterAsObserver(
            withSubject: KeyboardController.keyboardInfo,
            property: #selector(getter: KeyboardController.keyboardHeight),
            context: &_keyboardContext
        );
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.automaticallyAdjustsScrollViewInsets = false;
        self.sna_registerAsObserver(
        withSubject: KeyboardController.keyboardInfo,
        property: #selector(getter: KeyboardController.keyboardHeight),
        context: &_keyboardContext
        ) { [weak self] _,_,_ in
            if let sself = self {
                let previous = sself._tableView.contentInset;
                let inset = UIEdgeInsetsMake(
                    previous.top,
                    previous.left,
                    KeyboardController.keyboardInfo.keyboardHeight,
                    previous.right
                );
                sself._tableView.contentInset = inset;
                sself._tableView.scrollIndicatorInsets = inset;
            }
        }
    }

// MARK: protected
    override func _configureTableView() {
        super._configureTableView();
        if #available(iOS 9.0, *) {
            _tableView.cellLayoutMarginsFollowReadableWidth = false
        } else {
            // Fallback on earlier versions
        };
    }

    override func _configureCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        cell.selectionStyle = UITableViewCellSelectionStyle.gray;
        cell.preservesSuperviewLayoutMargins = false;
    }

// MARK: TableView
    func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero;
        cell.preservesSuperviewLayoutMargins = false;
        cell.layoutMargins = UIEdgeInsets.zero;
    }

}
