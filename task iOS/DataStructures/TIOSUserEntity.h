//
//  TIOSUserEntity.h
//  task iOS
//
//  Created by petr on 10/13/18.
//  Copyright © 2018 petr. All rights reserved.
//

#import "TIOSUser.h"

@interface TIOSUserEntity : TIOSUser

@property (assign, nonatomic) NSInteger id;
@property (strong, nonatomic) NSDate<Optional> *created;
@property (strong, nonatomic) NSDate<Optional> *updated;

@end
