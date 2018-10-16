//
//  UserCell.swift
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

class UserCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var firstName: UITextField?;
    @IBOutlet weak var lastName: UITextField?;
    @IBOutlet weak var email: UITextField?;
    @IBOutlet weak var imageUrl: UITextField?;
    
    @IBOutlet weak var firstNameLabel: UILabel?;
    @IBOutlet weak var lastNameLabel: UILabel?;
    @IBOutlet weak var emailLabel: UILabel?;
    @IBOutlet weak var imageUrlLabel: UILabel?;
    
    var cellModel: CreatingUserCellViewModel? {
        willSet {
            self._unsubscribe();
        }
        didSet {
            self._subscribe()
            
            self.firstName?.text = self.cellModel?.firstName;
            self.firstName?.placeholder = self.cellModel?.firstNamePlaceholder;
            
            self.lastName?.text = self.cellModel?.lastName;
            self.lastName?.placeholder = self.cellModel?.lastNamePlaceholder;
            
            self.email?.text = self.cellModel?.email;
            self.email?.placeholder = self.cellModel?.emailPlaceholder;
            
            self.imageUrl?.text = self.cellModel?.imageUrl;
            self.imageUrl?.placeholder = self.cellModel?.imageUrlPlaceholder
        }
    }
    

    deinit {
        self.firstName?.delegate = nil;
        self.lastName?.delegate = nil;
        self.email?.delegate = nil;
        self.imageUrl?.delegate = nil;
        
        self._unsubscribe();
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.firstName?.delegate = self;
        self.lastName?.delegate = self;
        self.email?.delegate = self;
        self.imageUrl?.delegate = self;
        
        self.email?.keyboardType = UIKeyboardType.emailAddress;
        self.imageUrl?.keyboardType = UIKeyboardType.URL;
        
        self.firstName?.clearButtonMode = UITextFieldViewMode.whileEditing;
        self.lastName?.clearButtonMode = UITextFieldViewMode.whileEditing;
        self.email?.clearButtonMode = UITextFieldViewMode.whileEditing;
        self.imageUrl?.clearButtonMode = UITextFieldViewMode.whileEditing;
        
        self.firstNameLabel?.text = "First Name".localized;
        self.lastNameLabel?.text = "Last Name".localized;
        self.emailLabel?.text = "Email".localized;
        self.imageUrlLabel?.text = "Avatar URL".localized;
    }
    
    override func prepareForReuse() {
        super.prepareForReuse();
        self.firstName?.text = nil;
        self.lastName?.text = nil;
        self.email?.text = nil;
        self.imageUrl?.text = nil;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: UITextFieldDelegate
@objc extension UserCell {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
        ) -> Bool {
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string);
        if textField === self.firstName {
            self.cellModel?.firstName = newString;
        }
        else if textField === self.lastName {
            self.cellModel?.lastName = newString;
        }
        else if textField === self.email {
            self.cellModel?.email = newString;
        }
        else if textField === self.imageUrl {
            self.cellModel?.imageUrl = newString;
        }
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
}

// MARK: Private
extension UserCell {
    
    private func _unsubscribe() {
        self.sna_unregisterAsObserver(
            withSubject: self.cellModel,
            property: #selector(getter: CreatingUserCellViewModel.firstNameBackground),
            context: &_firstNameContext
        );
        self.sna_unregisterAsObserver(
            withSubject: self.cellModel,
            property: #selector(getter: CreatingUserCellViewModel.lastNameBackground),
            context: &_lastNameContext
        );
        self.sna_unregisterAsObserver(
            withSubject: self.cellModel,
            property: #selector(getter: CreatingUserCellViewModel.emailBackground),
            context: &_emailContext
        );
        self.sna_unregisterAsObserver(
            withSubject: self.cellModel,
            property: #selector(getter: CreatingUserCellViewModel.imageUrlBackground),
            context: &_imageUrlContext
        );
    }
    
    private func _subscribe() {
        self.sna_registerAsObserver(
            withSubject: self.cellModel,
            property: #selector(getter: CreatingUserCellViewModel.firstNameBackground),
            context: &_firstNameContext
        ) { [weak self] _, _, _ in
            if let sself = self {
                sself.firstName?.background = sself.cellModel?.firstNameBackground;
            }
        };
        self.sna_registerAsObserver(
            withSubject: self.cellModel,
            property: #selector(getter: CreatingUserCellViewModel.lastNameBackground),
            context: &_lastNameContext
        ) { [weak self] _, _, _ in
            if let sself = self {
                sself.lastName?.background = sself.cellModel?.lastNameBackground;
            }
        };
        self.sna_registerAsObserver(
            withSubject: self.cellModel,
            property: #selector(getter: CreatingUserCellViewModel.emailBackground),
            context: &_emailContext
        ) { [weak self] _, _, _ in
            if let sself = self {
                sself.email?.background = sself.cellModel?.emailBackground;
            }
        };
        self.sna_registerAsObserver(
            withSubject: self.cellModel,
            property: #selector(getter: CreatingUserCellViewModel.imageUrlBackground),
            context: &_imageUrlContext
        ) { [weak self] _, _, _ in
            if let sself = self {
                sself.imageUrl?.background = sself.cellModel?.imageUrlBackground;
            }
        };
    }
    
}
