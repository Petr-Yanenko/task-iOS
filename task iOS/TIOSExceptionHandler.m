//
//  TIOSExceptionHandler.m
//  task iOS
//
//  Created by petr on 10/11/18.
//  Copyright © 2018 petr. All rights reserved.
//

#import "TIOSExceptionHandler.h"

NSString *const kTIOSDomain = @"TIOSDomain";

NSString *const kTIOSExceptionKey = @"TIOSExceptionKey";

@implementation TIOSExceptionHandler

+ (instancetype)instance {
    static TIOSExceptionHandler *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TIOSExceptionHandler alloc] init];
    });
    return instance;
}

- (BOOL)handleExceptionsWithBlock:(void (^)(void))block
                            error:(NSError *__autoreleasing *)error {
    @try {
        if (block) block();
        return YES;
    } @catch (NSException *exception) {
        if (error) {
            *error = [NSError errorWithDomain:kTIOSDomain
                                         code:kTIOSErrorCodeGeneric
                                     userInfo:@{
                                                kTIOSExceptionKey: exception
                                                }
                      ];
        }
        return NO;
    }
}

@end
