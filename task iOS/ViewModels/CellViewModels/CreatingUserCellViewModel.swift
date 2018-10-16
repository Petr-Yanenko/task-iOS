//
//  CreatingUserCellViewModel.swift
//  task iOS
//
//  Created by petr on 10/15/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

private var _firstNameContext: UInt8 = 0;
private var _lastNameContext: UInt8 = 0;
private var _emailContext: UInt8 = 0;
private var _imageUrlContext: UInt8 = 0;

class CreatingUserCellViewModel: BaseCellViewModel {
    
    var _userViewModel: CreatingUserViewModel {
        get {
            return self._viewModel as! CreatingUserViewModel;
        }
    }
    
    var _userModel: CreatingUserModel {
        get {
            return self._model as! CreatingUserModel;
        }
    }
    
    var firstName: String? {
        didSet {
            self._userModel.setFirstName(firstName);
        }
    };
    var lastName: String? {
        didSet {
            self._userModel.setLastName(lastName);
        }
    };
    var email: String? {
        didSet {
            self._userModel.setEmail(email)
        }
    };
    var imageUrl: String? {
        didSet {
            self._userModel.setImageUrl(imageUrl);
        }
    };
    
    let firstNamePlaceholder: String = "Enter your first name".localized;
    let lastNamePlaceholder: String = "Enter your last name".localized;
    let emailPlaceholder: String = "Enter your email".localized;
    let imageUrlPlaceholder: String = "Enter your avatar url".localized;
    
    var firstNameValid = false {
        didSet {
            self.firstNameBackground = self._createBackgroundImage(valid: self.firstNameValid);
        }
    }
    var lastNameValid = false {
        didSet {
            self.lastNameBackground = self._createBackgroundImage(valid: self.lastNameValid);
        }
    }
    var emailValid = false {
        didSet {
            self.emailBackground = self._createBackgroundImage(valid: self.emailValid);
        }
    }
    var imageUrlValid = false {
        didSet {
            self.imageUrlBackground = self._createBackgroundImage(valid: self.imageUrlValid);
        }
    }
    
    @objc dynamic var firstNameBackground = UIImage(color: UIColor.white);
    @objc dynamic var lastNameBackground = UIImage(color: UIColor.white);
    @objc dynamic var emailBackground = UIImage(color: UIColor.white);
    @objc dynamic var imageUrlBackground = UIImage(color: UIColor.white);
    
    
    deinit {
        self.sna_unregisterAsObserver(
            withSubject: self._userModel,
            property: #selector(getter: CreatingUserModel.firstNameValid),
            context: &_firstNameContext
        );
        self.sna_unregisterAsObserver(
            withSubject: self._userModel,
            property: #selector(getter: CreatingUserModel.lastNameValid),
            context: &_lastNameContext
        );
        self.sna_unregisterAsObserver(
            withSubject: self._userModel,
            property: #selector(getter: CreatingUserModel.emailValid),
            context: &_emailContext
        );
        self.sna_unregisterAsObserver(
            withSubject: self._userModel,
            property: #selector(getter: CreatingUserModel.imageUrlValid),
            context: &_imageUrlContext
        );
    }
    
    convenience init(userViewModel: CreatingUserViewModel, model: CreatingUserModel) {
        self.init(viewModel: userViewModel, model: model);
    }
    
    required init(viewModel: PViewModel, model: BaseModel) {
        //First stage of initialization
        
        super.init(viewModel: viewModel, model: model);
        
        //Second stage of initialization
        self.sna_registerAsObserver(
            withSubject: self._userModel,
            property: #selector(getter: CreatingUserModel.firstNameValid),
            context: &_firstNameContext
        ) { [weak self] _,_,_ in
            if let sself = self {
                sself.firstNameValid = sself._userModel.firstNameValid;
            }
        };
        self.sna_registerAsObserver(
            withSubject: self._userModel,
            property: #selector(getter: CreatingUserModel.lastNameValid),
            context: &_lastNameContext
        ) { [weak self] _,_,_ in
            if let sself = self {
                sself.lastNameValid = sself._userModel.lastNameValid;
            }
        };
        self.sna_registerAsObserver(
            withSubject: self._userModel,
            property: #selector(getter: CreatingUserModel.emailValid),
            context: &_emailContext
        ) { [weak self] _,_,_ in
            if let sself = self {
                sself.emailValid = sself._userModel.emailValid;
            }
        };
        self.sna_registerAsObserver(
            withSubject: self._userModel,
            property: #selector(getter: CreatingUserModel.imageUrlValid),
            context: &_imageUrlContext
        ) { [weak self] _,_,_ in
            if let sself = self {
                sself.imageUrlValid = sself._userModel.imageUrlValid;
            }
        };
    }
    
    override func configure(_ indexPath: IndexPath) {
        super.configure(indexPath);
        
        let userModel = self._userModel;
        let user = userModel.user;
        
        self.firstName = user?.firstName;
        self.lastName = user?.lastName;
        self.email = user?.email;
        self.imageUrl = user?.imageUrl;
        
        self.firstNameValid = userModel.firstNameValid;
        self.lastNameValid = userModel.lastNameValid;
        self.emailValid = userModel.emailValid;
        self.imageUrlValid = userModel.imageUrlValid;
    }

}

// MARK: Private
extension CreatingUserCellViewModel {
    
    private func _createBackgroundImage(valid: Bool) -> UIImage? {
        let color: UIColor;
        if valid {
            color = UIColor.white;
        }
        else {
            color = UIColor.red;
        }
        return UIImage(color: color)?.resizableImage(withCapInsets: UIEdgeInsets.zero);
    }
    
}
