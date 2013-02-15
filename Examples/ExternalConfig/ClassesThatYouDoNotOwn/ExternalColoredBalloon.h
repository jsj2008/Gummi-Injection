//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>

@class ExternalAir;

@interface ExternalColoredBalloon : NSObject
@property(nonatomic, copy) NSString *color;
@property(nonatomic, strong) ExternalAir *air;
- (id)initWithColor:(NSString *)color;
@end