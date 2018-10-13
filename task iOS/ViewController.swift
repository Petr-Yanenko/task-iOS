//
//  ViewController.swift
//  task iOS
//
//  Created by petr on 10/10/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var model: UsersModel;
    
    
    required init?(coder: NSCoder) {
        self.model = UsersModel();
        
        super.init(coder: coder);
        
        self.model.loadData();
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

