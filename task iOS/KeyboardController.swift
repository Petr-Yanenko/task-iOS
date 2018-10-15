//
// Created by Petr Yanenko on 9/26/16.
// Copyright (c) 2016 Petr Yanenko. All rights reserved.
//

import Foundation

class KeyboardController : NSObject {

    @objc dynamic var keyboardHeight : CGFloat = 0;
    @objc dynamic var duration : Double = 0;

    static let keyboardInfo : KeyboardController = KeyboardController();

    deinit {
        NotificationCenter.default.removeObserver(self);
    }

    override init() {
        super.init();
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(_handleWillShowKeyboardNotification(_:)),
                name: NSNotification.Name.UIKeyboardWillShow,
                object: nil
                );
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(_handleWillHideKeyboardNotification(_:)),
                name: NSNotification.Name.UIKeyboardWillHide,
                object: nil
                );
    }

}

// MARK: Notifications
@objc extension KeyboardController {

    func _handleWillShowKeyboardNotification(_ notification: Notification) -> Void {
        let keyboardRectValue = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue;
//        let curve = notification.userInfo[UIKeyboardAnimationCurveUserInfoKey];
        self._setDuration(notification);
        self.keyboardHeight = keyboardRectValue.cgRectValue.size.height;
    }

    func _handleWillHideKeyboardNotification(_ notification: Notification) -> Void {
        self._setDuration(notification);
        self.keyboardHeight = 0;
    }
    
}

// MARK: Private
extension KeyboardController {

    private func _setDuration(_ notification: Notification) -> Void {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber;
        self.duration = duration.doubleValue;
    }

}
