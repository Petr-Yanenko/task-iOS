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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self._tableView.rowHeight = UITableViewAutomaticDimension;
        self._tableView.estimatedRowHeight = 90.0;
        let usersNib = UINib(nibName: "UsersTableViewCell", bundle: nil);
        self._tableView.register(
            usersNib, forCellReuseIdentifier: self._usersViewModel.cellReuseIdentifier(nil)
        );
        self.title = "Users";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: Protected
extension UsersViewController {
    
    override func _configureCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        let usersCell = cell as! UsersTableViewCell;
        let userCellModel = self._usersViewModel.cellViewModel(indexPath) as! UsersCellViewModel;
        usersCell.avatar?.sd_setImage(with: userCellModel.imageURL);
        usersCell.content?.attributedText = userCellModel.content;
    }
    
}
