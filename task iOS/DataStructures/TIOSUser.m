//
//  TIOSUser.m
//  task iOS
//
//  Created by petr on 10/13/18.
//  Copyright © 2018 petr. All rights reserved.
//

#import "TIOSUser.h"

@implementation TIOSUser

+ (JSONKeyMapper *)keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

@end
