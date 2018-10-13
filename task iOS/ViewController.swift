//
//  ViewController.swift
//  task iOS
//
//  Created by petr on 10/10/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        do {
        let request =  try UsersRequest() { (request, responseObject, error) in
            print(responseObject);
        }
        request.execute();
        print("start request");
        }
        catch {
            print(error);
        }
    }


}

