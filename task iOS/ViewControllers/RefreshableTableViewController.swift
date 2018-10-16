//
// Created by Petr Yanenko on 8/25/16.
// Copyright (c) 2016 Petr Yanenko. All rights reserved.
//

import Foundation

class RefreshableTableViewController : CustomTableViewController {

    let _refreshControl : UIRefreshControl = UIRefreshControl();

// MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad();
        self._loadTableData();
    }

// MARK: protected
    override func _configureTableView() {
        super._configureTableView();
        _refreshControl.tintColor = UIColor(red: 0.635, green: 0.141, blue: 0247, alpha: 1.0);
        _refreshControl.addTarget(
                self,
                action: #selector(_refreshControlAction(_:)),
                for: UIControlEvents.valueChanged
                );
        _tableView.addSubview(_refreshControl);
    }

    @objc func _refreshControlAction(_ refreshControl: UIRefreshControl) {
        self._refresh(_refreshControl);
    }

    func _refresh(_ refreshControl: UIRefreshControl) {
        self._reloadTable();
        _refreshControl.endRefreshing();
    }

    func _reloadTable() {
        _tableViewModel.reload();
    }

    func _loadTableData() {
        _tableViewModel.loadData();
    }

// MARK: ScrollView
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height - scrollView.contentOffset.y <= scrollView.bounds.size.height {
            self._loadTableData();
        }
    }

}
