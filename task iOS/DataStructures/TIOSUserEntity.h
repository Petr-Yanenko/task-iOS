//
//  TIOSUserEntity.h
//  task iOS
//
//  Created by petr on 10/13/18.
//  Copyright © 2018 petr. All rights reserved.
//

#import "TIOSUser.h"

@protocol TIOSUserEntityProtocol <TIOSUserProtocol>

@property (assign, nonatomic, readonly) NSInteger id;
@property (strong, nonatomic, nullable, readonly) NSDate<Optional> *created;
@property (strong, nonatomic, nullable, readonly) NSDate<Optional> *updated;

@end

@interface TIOSUserEntity : TIOSUser <TIOSUserEntityProtocol>

@property (assign, nonatomic, readwrite) NSInteger id;
@property (strong, nonatomic, nullable, readwrite) NSDate<Optional> *created;
@property (strong, nonatomic, nullable, readwrite) NSDate<Optional> *updated;

@end
