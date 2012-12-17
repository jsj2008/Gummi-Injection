//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>

#define inject(args...) +(NSSet *)desiredProperties {return [NSSet setWithObjects: args, nil];}

@interface SDInjector : NSObject
+ (SDInjector *)sharedInjector;

- (id)getObject:(id)type;
- (void)injectIntoObject:(id)object;

- (void)map:(id)whenAskedFor to:(id)use asSingleton:(BOOL)asSingleton;
- (void)map:(id)whenAskedFor to:(id)use;
- (void)mapSingleton:(Class)aClass;
- (void)mapEagerSingleton:(Class)aClass;

- (BOOL)is:(id)whenAskedFor mappedTo:(id)use;

@end