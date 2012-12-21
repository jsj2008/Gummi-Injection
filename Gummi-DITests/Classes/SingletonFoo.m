
//
// Created by sschmid on 16.12.12.
//
// contact@sschmid.com
//


#import "SingletonFoo.h"
#import "SingletonBar.h"
#import "SDInjector.h"


static BOOL sToggle;

@implementation SingletonFoo
inject(@"bar")
@synthesize bar = _bar;

+ (BOOL)isInitialized {
    return sToggle;
}

- (id)init {
    NSLog(@"[%@ %s]", NSStringFromClass([self class]), sel_getName(_cmd));
    self = [super init];
    if (self) {
        sToggle = !sToggle;
    }

    return self;
}

- (void)dealloc {
    NSLog(@"[%@ %s]", NSStringFromClass([self class]), sel_getName(_cmd));
}


@end