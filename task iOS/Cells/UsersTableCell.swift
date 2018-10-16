//
//  UsersTableViewCell.swift
//  task iOS
//
//  Created by petr on 10/15/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit

class UsersTableCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView?;
    @IBOutlet weak var content: UILabel?;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.avatar?.layer.cornerRadius = ((self.avatar?.bounds.size.width) ?? 0.0) / 2.0;
        self.avatar?.clipsToBounds = true;
        self.avatar?.contentMode = UIViewContentMode.scaleAspectFit;
    }
    
    override func prepareForReuse() {
        super.prepareForReuse();
        self.avatar?.image = nil;
        self.content?.attributedText = nil;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
