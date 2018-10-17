//
//  UsersViewController.swift
//  task iOS
//
//  Created by petr on 10/15/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

class UsersViewController: CustomStyleViewController {
    
    private var _usersViewModel: UsersViewModel {
        get {
            return self._tableViewModel as! UsersViewModel;
        }
    }
    
    init(with viewModel: UsersViewModel) {
        super.init(with: viewModel);
    }
    
    required init?(coder: NSCoder) {
        return nil;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self._tableView.rowHeight = UITableViewAutomaticDimension;
        self._tableView.estimatedRowHeight = 90.0;
        let usersNib = UINib(nibName: "UsersTableCell", bundle: nil);
        self._tableView.register(
            usersNib, forCellReuseIdentifier: self._usersViewModel.cellReuseIdentifier(nil)
        );
        self.title = "Users".localized;
        
        let item = UIBarButtonItem(
            title: "New".localized,
            style: UIBarButtonItemStyle.plain,
            target: self,
            action: #selector(_newUserAction(_:))
        );
        self.navigationItem.rightBarButtonItem = item;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = EditingUserModel(
            user: self._usersViewModel.usersModel.getItem(at: indexPath.row) as! TIOSUserEntity
        );
        model.delegate = self._usersViewModel.usersModel;
        let viewModel = CreatingUserViewModel(model: model);
        let viewController = EditingUserViewController(with: viewModel);
        self.navigationController?.pushViewController(viewController, animated: true);
    }

}

// MARK: Protected
extension UsersViewController {
    
    override func _configureCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        let usersCell = cell as! UsersTableCell;
        let userCellModel = self._usersViewModel.cellViewModel(indexPath) as! UsersCellViewModel;
        if userCellModel.imageURL != nil {
            usersCell.avatar?.sd_setImage(with: userCellModel.imageURL);
        }
        else {
            let size: CGFloat = 44.0;
            usersCell.avatar?.image = UIImage(
                color: UIColor.darkGray,
                size: CGSize(width: size, height: size)
            );
        }
        usersCell.content?.attributedText = userCellModel.content;
    }
    
}

// MARK: Private
@objc extension UsersViewController {
    
    private func _newUserAction(_ sender: UIBarButtonItem) {
        let model = CreatingUserModel();
        model.delegate = self._usersViewModel.usersModel;
        let viewModel = CreatingUserViewModel(model: model);
        let viewController = CreatingUserViewController(with: viewModel);
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    
}
