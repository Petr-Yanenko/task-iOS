//
//  CreatingUserModel.swift
//  task iOS
//
//  Created by petr on 10/15/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

let kNumberOfNameSymbols = 2;

protocol CreatingUserModelDelegate: NSObjectProtocol {
    
    func userModel(_ model: CreatingUserModel, didReceiveUsers users: [TIOSUserEntity]?);
    
}

class CreatingUserModel: BaseModel {

    var _user: TIOSUserEntity = TIOSUserEntity();
    var user: TIOSUserEntityProtocol? {
        get {
            return _user;
        }
    }
    
    var users: [TIOSUserEntityProtocol]?
    
    weak var delegate: CreatingUserModelDelegate?
    
    @objc dynamic var firstNameValid = false;
    @objc dynamic var lastNameValid = false;
    @objc dynamic var emailValid = false;
    @objc dynamic var imageUrlValid = false;
    
    @objc dynamic var userSaved = false;
    
    
    func setFirstName(_ name: String?) {
        self._setInputData {
            self._user.firstName = name;
        }
    }
    
    func setLastName(_ name: String?) {
        self._setInputData {
            self._user.lastName = name;
        }
    }
    
    func setEmail(_ email: String?) {
        self._setInputData {
            self._user.email = email;
        }
    }
    
    func setImageUrl(_ url: String?) {
        self._setInputData {
            self._user.imageUrl = url;
        }
    }
    
    func validate() -> Bool {
        self.firstNameValid = self._validateName(self._user.firstName);
        self.lastNameValid = self._validateName(self._user.lastName);
        self.emailValid = self._validateEmail(self._user.email);
        self.imageUrlValid = self._validateUrl(self._user.imageUrl);
        
        return self.firstNameValid && self.lastNameValid && self.emailValid && self.imageUrlValid;
    }
    
    func save() {
        let valid = self.validate();
        if valid {
            self._startNetworkOperation();
        }
    }
    
    override func reset() {
        super.reset();
        self._user = TIOSUserEntity();
    }
    
    override func loadData() {
        self.newData = true;
    }
    
}

// MARK: Protected
extension CreatingUserModel {
    
    override func _request(with completion: @escaping (Any?, Error?) -> Void) throws -> BaseRequest {
        return try CreatingUserRequest(user: self._user) { _, responseObject, error in
            completion(responseObject, error);
        }
    }
    
    override func _setData(_ data: Any) {
        self.users = data as? [TIOSUserEntityProtocol];
        self.userSaved = true;
        self.delegate?.userModel(self, didReceiveUsers: data as? [TIOSUserEntity]);
    }
    
    func _setInputData(_ block: () -> Void) {
        block();
        _ = self.validate();
    }
    
    func _validateName(_ name: String?) -> Bool {
        let count = name?.count ?? 0;
        return count >= kNumberOfNameSymbols;
    }
    
    func _validateEmail(_ email: String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}";
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx);
        return emailPredicate.evaluate(with: email);
    }
    
    func _validateUrl(_ url: String?) -> Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        return url == nil || url!.count == 0 || NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with:url);
    }
    
}
