//
//  JSONValueTransformer+DataTransformer.m
//  task iOS
//
//  Created by petr on 10/13/18.
//  Copyright © 2018 petr. All rights reserved.
//

#import "JSONValueTransformer+DataTransformer.h"

@implementation JSONValueTransformer (DataTransformer)

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *instance = nil;
    if (!instance) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        instance = dateFormatter;
    }
    return instance;
}

- (NSDate *)NSDateFromNSString:(NSString *)string {
    return [[self dateFormatter] dateFromString:string];
}

- (NSString *)NSStringFromNSDate:(NSDate *)date {
    return [[self dateFormatter] stringFromDate:date];
}

- (NSInteger)NSInegerFromNSString:(NSString *)string {
    return [string integerValue];
}

- (NSString *)NSStringFromNSInteger:(NSInteger)integer {
    return [[NSString alloc] initWithFormat:@"%lu", integer];
}

@end
