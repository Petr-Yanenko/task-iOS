//
// Created by Petr Yanenko on 8/30/16.
// Copyright (c) 2016 Petr Yanenko. All rights reserved.
//

import Foundation

class NavigationController : UINavigationController, UIGestureRecognizerDelegate {

// MARK: lifecycle
    deinit {
        if let recognizer =  self.interactivePopGestureRecognizer {
            recognizer.delegate = nil;
        }
    }

    override func viewDidLoad() -> Void {
        super.viewDidLoad();
        var stringAttributes = [NSAttributedStringKey: AnyObject]();
        stringAttributes[NSAttributedStringKey.foregroundColor] = kMainTextColor;
        stringAttributes[NSAttributedStringKey.font] = kNavigationBarFont;
        self.navigationBar.titleTextAttributes = stringAttributes;

        let mainColor = kMainBackgroundColor;

        self.view.backgroundColor = mainColor;
        self.navigationBar.barTintColor = mainColor;
        self.navigationBar.tintColor = kMainTintColor;
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default);
        self.navigationBar.shadowImage = UIImage();
        self.navigationBar.isTranslucent = false;

        if let recognizer = self.interactivePopGestureRecognizer {
            recognizer.delegate = self;
        }
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }

}
