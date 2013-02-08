//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "GIInjectorEntry.h"

@interface GIInjectorClassEntry : GIInjectorEntry
- (id)initWithObject:(id)object mappedTo:(id)keyObject asSingleton:(BOOL)singleton injector:(GIInjector *)injector;
@end