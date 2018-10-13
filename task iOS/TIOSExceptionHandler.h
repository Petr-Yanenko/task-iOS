//
//  TIOSExceptionHandler.h
//  task iOS
//
//  Created by petr on 10/11/18.
//  Copyright © 2018 petr. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *const kTIOSDomain;

NSString *const kTIOSExceptionKey;

typedef NS_ENUM(NSInteger, TIOSErrorCode) {
    kTIOSErrorCodeGeneric = 0
};

NS_ASSUME_NONNULL_BEGIN

@interface TIOSExceptionHandler : NSObject

+ (instancetype)instance;

- (BOOL)handleExceptionsWithBlock:(void (^)(void))block
                            error:(NSError *__autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
