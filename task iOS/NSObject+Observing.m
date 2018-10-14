//
//  NSObject+Observing.m
//  simple_notes_app
//
//  Created by Petr Yanenko on 9/27/18.
//  Copyright © 2018 Petr Yanenko. All rights reserved.
//

#import "NSObject+Observing.h"
#import <objc/runtime.h>


@interface NSObject ()

@property (strong, nonatomic, readonly) NSMutableDictionary *observers;

@end

@implementation NSObject (Observing)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(observeValueForKeyPath:ofObject:change:context:);
        SEL swizzledSelector = @selector(sna_observeValueForKeyPath:ofObject:change:context:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);

        BOOL didAddMethod =
            class_addMethod(
                            class,
                            originalSelector,
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod)
                            );

        if (didAddMethod) {
            class_replaceMethod(
                                class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod)
                                );
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (NSMutableDictionary *)observers {
    SEL identifier = @selector(observers);
    NSMutableDictionary *observers = objc_getAssociatedObject(self, identifier);
    if (!observers) {
        observers = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, identifier, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return observers;
}

- (NSString *)keyPathFromProperty:(SEL)property {
    return NSStringFromSelector(property);
}

- (NSValue *)valueFromContext:(void *)context {
    return [NSValue valueWithPointer:context];
}

- (void)sna_registerAsObserverWithSubject:(NSObject *)subject
                                 property:(SEL)property
                                  context:(void *)context
                                  handler:(SNAObserver)handler {
    [subject addObserver:self
              forKeyPath:[self keyPathFromProperty:property]
                 options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                 context:context
     ];
    NSValue *contextValue = [self valueFromContext:context];
    self.observers[contextValue] = handler;
}

- (void)sna_unregisterAsObserverWithSubject:(NSObject *)subject
                                   property:(SEL)property
                                    context:(void *)context {
    [subject removeObserver:self
                 forKeyPath:[self keyPathFromProperty:property]
                    context:context
     ];
    [self.observers removeObjectForKey:[self valueFromContext:context]];
}

- (void)sna_observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    SNAObserver observer = self.observers[[self valueFromContext:context]];
    if (observer) {
        observer(object, change[NSKeyValueChangeOldKey], change[NSKeyValueChangeNewKey]);
    }
    else {
        [self sna_observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
