//
// Created by Petr Yanenko on 8/30/16.
// Copyright (c) 2016 Petr Yanenko. All rights reserved.
//

import Foundation

@objc class ContainerViewController: UISplitViewController, UISplitViewControllerDelegate {

// MARK: lifecycle
    deinit {
        self.delegate = nil;
    }
    
    override func viewDidLoad() -> Void {
        super.viewDidLoad();
        self.setNeedsStatusBarAppearanceUpdate();
        self.delegate = self;
        self.preferredDisplayMode = UISplitViewControllerDisplayMode.primaryOverlay;
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }
}

// MARK: SplitViewController
@objc extension ContainerViewController {
    
    func splitViewController(
            _ splitViewController: UISplitViewController,
            collapseSecondary secondViewController: UIViewController,
            onto viewController: UIViewController
        ) -> Bool {
        return self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone;
    }

}
