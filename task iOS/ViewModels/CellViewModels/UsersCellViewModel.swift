//
//  UsersCellViewModel.swift
//  task iOS
//
//  Created by petr on 10/15/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

class UsersCellViewModel: BaseCellViewModel {
    
    var _usersViewModel: UsersViewModel {
        get {
            return self._viewModel as! UsersViewModel;
        }
    }
    
    var _usersModel: UsersModel {
        get {
            return self._model as! UsersModel;
        }
    }
    
    var id: Int = 0;
    var firstName: String?;
    var lastName: String?;
    var email: String?;
    var imageURL: URL?;
    var created: String?;
    var updated: String?;
    
    lazy var content: NSAttributedString = {
        func createDate(with date: String?, title: String) -> NSAttributedString {
            return NSAttributedString(
                string: "\n\(title): \(checkString(date))",
                attributes: [
                    NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10.0)
                ]
            );
        }
        func checkString(_ string: String?) -> String {
            return string ?? "";
        }
        
        let items = [
            NSAttributedString(
                string: "\("First Name".localized): \(checkString(self.firstName))",
                attributes: [
                    NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16.0)
                ]
            ),
            NSAttributedString(
                string: "\n\("Last Name".localized): \(checkString(self.lastName))",
                attributes: [
                    NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14.0)
                ]
            ),
            NSAttributedString(
                string: "\n\("Email".localized): \(checkString(self.email))",
                attributes: [
                    NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0)
                ]
            ),
            
            createDate(with: self.created, title: "Created".localized),
            createDate(with: self.updated, title: "Updated".localized)
        ];
        
        let content = NSMutableAttributedString(string: "");
        for el in items {
            content.append(el);
        }
        
        return content;
    }()
    
    private lazy var _dateFormatter: DateFormatter = {
        let formatter = DateFormatter();
        formatter.dateStyle = DateFormatter.Style.medium;
        formatter.timeStyle = DateFormatter.Style.short;
        return formatter;
    }()
    
    
    init(viewModel: UsersViewModel, model: UsersModel) {
        super.init(viewModel: viewModel, model: model);
    }
    
    required init(viewModel: PViewModel, model: BaseModel) {
        super.init(viewModel: viewModel, model: model);
    }
    
    override func configure(_ indexPath: IndexPath) {
        super.configure(indexPath);
        
        let usersModel = self._usersModel;
        let user = usersModel.getItem(at: indexPath.row) as! TIOSUserEntityProtocol;
        
        self.id = user.id;
        self.firstName = user.firstName;
        self.lastName = user.lastName;
        self.email = user.email;
        if let url = user.imageUrl {
            self.imageURL = URL(string: url);
        }
        if let created = user.created {
            self.created = self._dateFormatter.string(from: created);
        }
        if let updated = user.updated {
            self.updated = self._dateFormatter.string(from: updated);
        }
    }
    
}
