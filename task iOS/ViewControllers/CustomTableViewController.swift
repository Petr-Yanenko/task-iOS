//
// Created by Petr Yanenko on 8/24/16.
// Copyright (c) 2016 Petr Yanenko. All rights reserved.
//

import Foundation

private var _newDataContext: UInt8 = 0;

class CustomTableViewController : BaseViewController, UITableViewDataSource, UITableViewDelegate {

    var _tableView : UITableView = UITableView();
    var _tableViewModel : TableViewModel { get { return _viewModel as! TableViewModel; } }

// MARK: lifecycle
    deinit {
        self._tableView.dataSource = nil;
        self._tableView.delegate = nil;
        self.sna_unregisterAsObserver(
            withSubject:_tableViewModel,
            property:#selector(getter: PViewModel.newData),
            context:&_newDataContext
        );
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        _tableView.selectRow(
            at: nil, animated: true, scrollPosition: UITableViewScrollPosition.none
        );
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        _tableView.flashScrollIndicators();
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        _tableView.reloadData();
    }
}

// MARK: protected
@objc extension CustomTableViewController {
    
    override func _addObservers() {
        super._addObservers();
        self.sna_registerAsObserver(
            withSubject:self._tableViewModel,
            property:#selector(getter: PViewModel.newData),
            context:&_newDataContext
        ) { [weak self] subject, old, new in
                if let sself = self {
                    sself._tableView.reloadData();
                }
            }
    }
    
    override func _createScreenContent() {
        super._createScreenContent();
        self._configureTableView();
    }
    
    override func _addSubviews() {
        super._addSubviews();
        self.view.addSubview(self._tableView);
    }
    
    override func _addConstraints() {
        self._tableView.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addConstraints(
            NSLayoutConstraint .constraints(
                withVisualFormat: "H:|[tableView]|",
                options: NSLayoutFormatOptions.directionLeadingToTrailing,
                metrics: nil,
                views: ["tableView": self._tableView]
            )
        );
        self.view.addConstraints(
            NSLayoutConstraint .constraints(
                withVisualFormat: "V:[topLayoutGuide][tableView][bottomLayoutGuide]",
                options: NSLayoutFormatOptions.directionLeadingToTrailing,
                metrics: nil,
                views: [
                    "tableView": self._tableView,
                    "topLayoutGuide": self.topLayoutGuide,
                    "bottomLayoutGuide": self.bottomLayoutGuide
                ]
            )
        );
    }

    func _configureTableView() {
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = UIView();
    }

    func _configureCell(_ cell: UITableViewCell, indexPath: IndexPath) {

    }

    func _createCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell();
    }
    
}

// MARK: TableView
@objc extension CustomTableViewController {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return _tableViewModel.rowHeight(tableView.bounds.size.height, indexPath: indexPath);
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _tableViewModel.selectRowAction(indexPath);
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _tableViewModel.cellsNumber(section);
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: _tableViewModel.cellReuseIdentifier(indexPath)
        );
        let newCell : UITableViewCell;
        if let unwrappedCell = cell {
            newCell = unwrappedCell;
        } else {
            newCell = self._createCell(tableView, indexPath: indexPath);
        }
        self._configureCell(newCell, indexPath: indexPath);
        return newCell;
    }

}
