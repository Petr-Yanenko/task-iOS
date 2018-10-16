//
//  CreatingUserViewController.swift
//  task iOS
//
//  Created by petr on 10/15/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

private var _loadingContext: UInt8 = 0;
private var _savingUserContext: UInt8 = 0;
private var _keyboardContext: UInt8 = 0;

class CreatingUserViewController: CustomStyleViewController {
    
    private var _userViewModel: CreatingUserViewModel {
        get {
            return self._viewModel as! CreatingUserViewModel;
        }
    }
    
    private var _hud: MBProgressHUD?
    

    deinit {
        self.sna_unregisterAsObserver(
            withSubject:_tableViewModel,
            property:#selector(getter: PViewModel.loading),
            context:&_loadingContext
        );
        self.sna_unregisterAsObserver(
            withSubject:_tableViewModel,
            property:#selector(getter: CreatingUserViewModel.userSaved),
            context:&_savingUserContext
        );
        
        self._hud?.hide(animated: false);
    }
    
    init(with viewModel: CreatingUserViewModel) {
        super.init(with: viewModel);
    }
    
    required init?(coder: NSCoder) {
        return nil;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self._tableView.rowHeight = UITableViewAutomaticDimension;
        self._tableView.estimatedRowHeight = 175.0;
        let usersNib = UINib(nibName: "UserCell", bundle: nil);
        self._tableView.register(
            usersNib, forCellReuseIdentifier: self._userViewModel.cellReuseIdentifier(nil)
        );
        self.title = self._screenTitle().localized;
        
        let saveButton = UIBarButtonItem(
            title: self._rightBarButtonItemTitle().localized,
            style: UIBarButtonItemStyle.plain,
            target: self,
            action: #selector(_createUserAction(_:))
        );
        self.navigationItem.rightBarButtonItem = saveButton;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }

}

// MARK: Protected
@objc extension CreatingUserViewController {
    
    override func _configureCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        let userCell = cell as! UserCell;
        let userCellModel = self._userViewModel.cellViewModel(indexPath) as! CreatingUserCellViewModel;
        userCell.cellModel = userCellModel;
    }
    
    override func _addObservers() {
        super._addObservers();
        self.sna_registerAsObserver(
            withSubject:_tableViewModel,
            property:#selector(getter: PViewModel.loading),
            context:&_loadingContext
        ) { [weak self] _,_,_ in
            if let sself = self {
                sself._hud?.hide(animated: true);
                sself.navigationItem.rightBarButtonItem?.isEnabled = true;
                if sself._userViewModel.loading {
                    sself._hud = MBProgressHUD.showAdded(to: sself.view, animated: true);
                    sself.navigationItem.rightBarButtonItem?.isEnabled = false;
                }
            }
        }
        self.sna_registerAsObserver(
            withSubject:_tableViewModel,
            property:#selector(getter: CreatingUserViewModel.userSaved),
            context:&_savingUserContext
        ) { [weak self] _,_,_ in
            if let sself = self {
                sself._userSaved();
            }
        }
    }
    
    func _userSaved() {
        self.navigationController?.popViewController(animated: true);
    }
    
    func _screenTitle() -> String {
        return "Create User";
    }
    
    func _rightBarButtonItemTitle() -> String {
        return "Create";
    }
    
}

// MARK: Private
@objc extension CreatingUserViewController {
    
    private func _createUserAction(_ sender: UIBarButtonItem) {
        self._userViewModel.save();
        self.view.endEditing(true);
    }
    
}
