//
// Created by Petr Yanenko on 8/24/16.
// Copyright (c) 2016 Petr Yanenko. All rights reserved.
//

import Foundation

class BaseViewController : UIViewController {
    
    var _bottomConstraint : NSLayoutConstraint = NSLayoutConstraint();

    var _viewModel : PViewModel;
//    var _router : PRouter?;

// MARK: lifecycle
    deinit {
        self._viewModel.cancel();
    }

    init(with viewModel: PViewModel) {
        //First stage of initialization
        _viewModel = viewModel;
        
        super.init(nibName: nil, bundle: nil);
        
        //Second stage of initialization
    }

    required init?(coder: NSCoder) {
        return nil;
        super.init(coder: coder);
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        self._addObservers();
        self._createScreenContent();
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        if (self.isBeingDismissed || self.isMovingFromParentViewController) {
            self._viewModel.cancel();
        }
    }
}

// MARK: protected
@objc extension BaseViewController {

    func _addObservers() {
        
    }

    func _createScreenContent() {
        self._addSubviews();
        self._addConstraints();
    }
    
    func _addSubviews() {
        
    }
    
    func _addConstraints() {
        
    }

}
