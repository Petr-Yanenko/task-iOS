//
//  TIOSUser.h
//  task iOS
//
//  Created by petr on 10/13/18.
//  Copyright © 2018 petr. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol TIOSUserProtocol <NSObject>

@property (copy, nonatomic, nullable, readonly) NSString<Optional> *firstName;
@property (copy, nonatomic, nullable, readonly) NSString<Optional> *lastName;
@property (copy, nonatomic, nullable, readonly) NSString<Optional> *email;
@property (copy, nonatomic, nullable, readonly) NSString<Optional> *imageUrl;

@end

@interface TIOSUser : JSONModel <TIOSUserProtocol>

@property (copy, nonatomic, nullable, readwrite) NSString<Optional> *firstName;
@property (copy, nonatomic, nullable, readwrite) NSString<Optional> *lastName;
@property (copy, nonatomic, nullable, readwrite) NSString<Optional> *email;
@property (copy, nonatomic, nullable, readwrite) NSString<Optional> *imageUrl;

@end
