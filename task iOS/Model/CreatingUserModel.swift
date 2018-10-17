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
    
    func userModel(_ model: CreatingUserModel, didReceiveResponse object: Any?);
    
}

class CreatingUserModel: BaseModel {

    var _user: TIOSUserEntity = TIOSUserEntity();
    var user: TIOSUserEntityProtocol? {
        get {
            return _user;
        }
    }
    
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
            self._user.firstName = self.user?.firstName?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines);
            self._user.lastName = self.user?.lastName?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines);
            self._user.email = self.user?.email?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines);
            self._user.imageUrl = self.user?.imageUrl?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines);
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
    
    override func _processResponse(_ responseObject: Any?, _ error: Error?) {
        super._processResponse(responseObject, error);
        self.userSaved = true;
        self.delegate?.userModel(self, didReceiveResponse: responseObject);
    }
    
    func _setInputData(_ block: () -> Void) {
        block();
        _ = self.validate();
    }
    
    func _validateName(_ name: String?) -> Bool {
        let count = name?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count ?? 0;
        return count >= kNumberOfNameSymbols;
    }
    
    func _validateEmail(_ email: String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}";
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx);
        return emailPredicate.evaluate(with: email?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines));
    }
    
    func _validateUrl(_ urlString: String?) -> Bool {
        let url = urlString?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines);
        return url == nil || url!.count == 0 || URL(string: url!) != nil;
    }
    
}
