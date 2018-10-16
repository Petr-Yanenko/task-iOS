//
//  EditingUserViewController.swift
//  task iOS
//
//  Created by petr on 10/16/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

class EditingUserViewController: CreatingUserViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
    
// MARK: Protected
extension EditingUserViewController {
    
    override func _userSaved() {
        let alert = UIAlertController.init(title: "Saved".localized, message: nil, preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(
            title: "Ok".localized,
            style: UIAlertActionStyle.default,
            handler: nil
            )
        );
        self.present(alert, animated: true, completion: nil);
    }
    
    override func _screenTitle() -> String {
        return "Edit User";
    }
    
    override func _rightBarButtonItemTitle() -> String {
        return "Save";
    }

}
