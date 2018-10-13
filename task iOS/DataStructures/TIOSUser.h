//
//  TIOSUser.h
//  task iOS
//
//  Created by petr on 10/13/18.
//  Copyright © 2018 petr. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TIOSUser : JSONModel

@property (copy, nonatomic) NSString<Optional> *firstName;
@property (copy, nonatomic) NSString<Optional> *lastName;
@property (copy, nonatomic) NSString<Optional> *email;
@property (copy, nonatomic) NSString<Optional> *imageUrl;

@end
