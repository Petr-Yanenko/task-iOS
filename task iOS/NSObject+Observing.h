//
//  NSObject+Observing.h
//  simple_notes_app
//
//  Created by Petr Yanenko on 9/27/18.
//  Copyright © 2018 Petr Yanenko. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^SNAObserver)(id subject, id old, id new);

@interface NSObject (Observing)

- (void)sna_registerAsObserverWithSubject:(NSObject *)subject
                                 property:(SEL)property
                                  context:(void *)context
                                  handler:(SNAObserver)handler;

- (void)sna_unregisterAsObserverWithSubject:(NSObject *)subject
                                   property:(SEL)property
                                    context:(void *)context;

@end
