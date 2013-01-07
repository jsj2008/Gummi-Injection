//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "Kiwi.h"
#import "GIInjector.h"
#import "Car.h"
#import "Garage.h"
#import "SingletonFoo.h"
#import "SingletonBar.h"
#import "HybridMotor.h"
#import "Wheel.h"
#import "GIModule.h"
#import "SingletonModule.h"
#import "StartStopModule.h"
#import "StartStopObject.h"

SPEC_BEGIN(GIInjectorSpec)

        describe(@"GIInjector", ^{

            __block GIInjector *injector;
            beforeEach(^{
                injector = [[GIInjector alloc] init];
            });

            it(@"instantiates an injector", ^{
                [[injector should] beKindOfClass:[GIInjector class]];
            });

            it(@"returns shared injector", ^{
                [[[GIInjector sharedInjector] should] equal:[GIInjector sharedInjector]];
            });

            it(@"has no mappings", ^{
                [[theValue([injector isObject:[Car class] mappedTo:[Car class]]) should] beNo];
            });

            it(@"retrieves objects from empty context", ^{
                Wheel *wheel = [injector getObject:[Wheel class]];

                [[wheel should] beKindOfClass:[Wheel class]];
            });

            it(@"raises exception when asking for unmapped protocol", ^{
                [[theBlock(^{
                    [injector getObject:@protocol(Vehicle)];
                }) should] raiseWithName:@"GIInjectorException"];
            });

            it(@"raises exception when class does not conform to protocol", ^{
                [[theBlock(^{
                    [injector map:[NSObject class] to:@protocol(Vehicle)];
                }) should] raiseWithName:@"GIInjectorEntryException"];
            });

            context(@"when context has classes mapped", ^{

                __block Car *car;
                __block Garage *garage;
                beforeEach(^{
                    [injector map:[Car class] to:[Car class]];
                    [injector map:[Garage class] to:[Garage class]];
                    [injector map:[HybridMotor class] to:@protocol(Motor)];
                    car = [injector getObject:[Car class]];
                    garage = [injector getObject:[Garage class]];
                });

                it(@"has mapping", ^{
                    BOOL m1 = [injector isObject:[Car class] mappedTo:[Car class]];
                    BOOL m2 = [injector isObject:[Garage class] mappedTo:[Garage class]];
                    BOOL m3 = [injector isObject:[HybridMotor class] mappedTo:@protocol(Motor)];

                    [[theValue(m1) should] beYes];
                    [[theValue(m2) should] beYes];
                    [[theValue(m3) should] beYes];
                });

                it(@"pulls object from context", ^{
                    [[car should] beKindOfClass:[Car class]];
                    [[garage should] beKindOfClass:[Garage class]];
                });

                it(@"returns new instances", ^{
                    [[[injector getObject:[Car class]] shouldNot] equal:[injector getObject:[Car class]]];
                });

                it(@"pulls object with all its dependecies set", ^{
                    [[theValue(car.canDrive) should] beYes];
                    [[theValue(garage.isFull) should] beYes];
                });

                it(@"sets dependencies of dependencies", ^{
                    [[theValue(garage.audi.canDrive) should] beYes];
                    [[theValue(garage.bmw.canDrive) should] beYes];
                    [[theValue(garage.mercedes.canDrive) should] beYes];
                });

            });

            context(@"when context has protocols mapped", ^{

                __block Car *car;
                __block Garage *garage;
                beforeEach(^{
                    [injector map:[Car class] to:@protocol(Vehicle)];
                    [injector map:[Garage class] to:[Garage class]];
                    [injector map:[HybridMotor class] to:@protocol(Motor)];
                    car = [injector getObject:@protocol(Vehicle)];
                    garage = [injector getObject:[Garage class]];
                });

                it(@"has mapping", ^{
                    BOOL m1 = [injector isObject:[Car class] mappedTo:@protocol(Vehicle)];
                    BOOL m2 = [injector isObject:[Garage class] mappedTo:[Garage class]];
                    BOOL m3 = [injector isObject:[HybridMotor class] mappedTo:@protocol(Motor)];

                    [[theValue(m1) should] beYes];
                    [[theValue(m2) should] beYes];
                    [[theValue(m3) should] beYes];
                });

                it(@"pulls object from context", ^{
                    [[car should] beKindOfClass:[Car class]];
                    [[garage should] beKindOfClass:[Garage class]];
                });

                it(@"pulls object with all its dependecies set", ^{
                    [[theValue(car.canDrive) should] beYes];
                    [[theValue(garage.isFull) should] beYes];
                });

                it(@"sets dependencies of dependencies", ^{
                    [[theValue(garage.audi.canDrive) should] beYes];
                    [[theValue(garage.bmw.canDrive) should] beYes];
                    [[theValue(garage.mercedes.canDrive) should] beYes];
                });

            });

            context(@"when context has singletons mapped", ^{

                __block Car *car;
                __block Garage *garage;
                beforeEach(^{
                    [injector mapSingleton:[Car class] to:@protocol(Vehicle) lazy:YES];
                    [injector mapSingleton:[Garage class] to:[Garage class] lazy:YES];
                    [injector map:[HybridMotor class] to:@protocol(Motor)];
                    car = [injector getObject:@protocol(Vehicle)];
                    garage = [injector getObject:[Garage class]];

                });

                it(@"has mapping", ^{
                    BOOL m1 = [injector isObject:[Car class] mappedTo:@protocol(Vehicle)];
                    BOOL m2 = [injector isObject:[Garage class] mappedTo:[Garage class]];
                    BOOL m3 = [injector isObject:[HybridMotor class] mappedTo:@protocol(Motor)];

                    [[theValue(m1) should] beYes];
                    [[theValue(m2) should] beYes];
                    [[theValue(m3) should] beYes];
                });

                it(@"pulls object from context", ^{
                    [[car should] beKindOfClass:[Car class]];
                });

                it(@"always returns same instance", ^{
                    [[[injector getObject:@protocol(Vehicle)] should] equal:[injector getObject:@protocol(Vehicle)]];
                    [[[injector getObject:[Garage class]] should] equal:[injector getObject:[Garage class]]];
                });

                it(@"pulls object with all its dependecies set", ^{
                    [[theValue(car.canDrive) should] beYes];
                    [[theValue(garage.isFull) should] beYes];
                });

                it(@"sets dependencies of dependencies", ^{
                    [[theValue(garage.audi.canDrive) should] beYes];
                    [[theValue(garage.bmw.canDrive) should] beYes];
                    [[theValue(garage.mercedes.canDrive) should] beYes];
                });
            });

            context(@"when circular dependency", ^{

                it(@"will be resolved for singletons", ^{
                    [injector mapSingleton:[SingletonFoo class] to:[SingletonFoo class] lazy:YES];
                    [injector mapSingleton:[SingletonBar class] to:[SingletonBar class] lazy:YES];
                    SingletonFoo *foo = [injector getObject:[SingletonFoo class]];
                    SingletonBar *bar = [injector getObject:[SingletonBar class]];

                    [[foo.bar should] equal:bar];
                    [[bar.foo should] equal:foo];
                });

            });

            context(@"when context has instance mapped", ^{

                __block Car *mappedCar;
                __block Car *retrievedCar;
                __block Garage *garage;
                beforeEach(^{
                    [injector map:[HybridMotor class] to:@protocol(Motor)];
                    mappedCar = [Car car];
                    garage = [[Garage alloc] init];
                    [injector map:mappedCar to:@protocol(Vehicle)];
                    [injector map:garage to:[Garage class]];
                    retrievedCar = [injector getObject:@protocol(Vehicle)];
                });

                it(@"has mapping", ^{
                    BOOL m1 = [injector isObject:[HybridMotor class] mappedTo:@protocol(Motor)];
                    BOOL m2 = [injector isObject:mappedCar mappedTo:@protocol(Vehicle)];
                    BOOL m3 = [injector isObject:garage mappedTo:[Garage class]];

                    BOOL m4 = [injector isObject:[Garage class] mappedTo:[Garage class]];
                    BOOL m5 = [injector isObject:[[Garage alloc] init] mappedTo:[Garage class]];
                    BOOL m6 = [injector isObject:[Car class] mappedTo:[Car class]];
                    BOOL m7 = [injector isObject:[Car car] mappedTo:[Car class]];

                    [[theValue(m1) should] beYes];
                    [[theValue(m2) should] beYes];
                    [[theValue(m3) should] beYes];

                    [[theValue(m4) should] beNo];
                    [[theValue(m5) should] beNo];
                    [[theValue(m6) should] beNo];
                    [[theValue(m7) should] beNo];
                });

                it(@"returns instance", ^{
                    [[retrievedCar should] equal:mappedCar];
                });

                it(@"pulls object with all its dependecies set", ^{
                    [[theValue(mappedCar.canDrive) should] beYes];
                    [[theValue(retrievedCar.canDrive) should] beYes];
                    [[theValue(garage.isFull) should] beYes];
                });

                it(@"sets dependencies of dependencies", ^{
                    [[theValue(garage.audi.canDrive) should] beYes];
                    [[theValue(garage.bmw.canDrive) should] beYes];
                    [[theValue(garage.mercedes.canDrive) should] beYes];
                });

            });

            context(@"when context has protocol mapped", ^{

                it(@"raises exception", ^{
                    [[theBlock(^{
                        [injector map:[NSObject class] to:@protocol(Vehicle)];
                    }) should] raiseWithName:@"GIInjectorEntryException"];
                });

            });

            context(@"when context has eager", ^{

                it(@"creates instance", ^{
                    BOOL wasToggled = [SingletonFoo isInitialized];
                    [injector mapSingleton:[SingletonFoo class] to:[SingletonFoo class] lazy:NO];
                    BOOL isToggled = [SingletonFoo isInitialized];

                    [[theValue(wasToggled) shouldNot] equal:theValue(isToggled)];
                });

                it(@"always return same instance", ^{
                    [injector mapSingleton:[SingletonFoo class] to:[SingletonFoo class] lazy:NO];

                    [[[injector getObject:[SingletonFoo class]] should] equal:[injector getObject:[SingletonFoo class]]];
                });

            });

            it(@"removes mappings", ^{
                [injector map:[Car class] to:@protocol(Vehicle)];
                BOOL has1 = [injector isObject:[Car class] mappedTo:@protocol(Vehicle)];
                [injector unMap:[Car class] from:@protocol(Vehicle)];
                BOOL has2 = [injector isObject:[Car class] mappedTo:@protocol(Vehicle)];

                [[theValue(has1) should] beYes];
                [[theValue(has2) should] beNo];
            });

            it(@"has no module class", ^{
                BOOL has = [injector hasModuleClass:[GIModule class]];
                [[theValue(has) should] beNo];
            });

            it(@"has no module", ^{
                BOOL has = [injector hasModule:[[GIModule alloc] init]];
                [[theValue(has) should] beNo];
            });

            context(@"when added a module", ^{

                __block SingletonModule *singletonModule;
                beforeEach(^{
                    singletonModule = [[SingletonModule alloc] init];
                    [injector addModule:singletonModule];
                });

                it(@"has module", ^{
                    BOOL has = [injector hasModule:singletonModule];
                    [[theValue(has) should] beYes];
                });

                it(@"has module class", ^{
                    BOOL has = [injector hasModuleClass:[SingletonModule class]];
                    [[theValue(has) should] beYes];
                });

                it(@"has modules mappings", ^{
                    BOOL has = [injector isObject:[SingletonFoo class] mappedTo:[SingletonFoo class]];
                    [[theValue(has) should] beYes];
                });

                context(@"when removed module", ^{

                    beforeEach(^{
                        [injector removeModule:singletonModule];
                    });

                    it(@"has no module", ^{
                        BOOL has = [injector hasModule:singletonModule];
                        [[theValue(has) should] beNo];
                    });

                    it(@"has no module class", ^{
                        BOOL has = [injector hasModuleClass:[SingletonModule class]];
                        [[theValue(has) should] beNo];
                    });

                    it(@"has no modules mappings", ^{
                        BOOL has = [injector isObject:[SingletonFoo class] mappedTo:[SingletonFoo class]];
                        [[theValue(has) should] beNo];
                    });

                });

                context(@"when removed module class", ^{

                    beforeEach(^{
                        [injector removeModuleClass:[SingletonModule class]];
                    });

                    it(@"has no module", ^{
                        BOOL has = [injector hasModule:singletonModule];
                        [[theValue(has) should] beNo];
                    });

                    it(@"has no module class", ^{
                        BOOL has = [injector hasModuleClass:[SingletonModule class]];
                        [[theValue(has) should] beNo];
                    });

                    it(@"has no modules mappings", ^{
                        BOOL has = [injector isObject:[SingletonFoo class] mappedTo:[SingletonFoo class]];
                        [[theValue(has) should] beNo];
                    });

                });

            });

            context(@"module lifecycle", ^{

                __block StartStopModule *startStopModule;
                beforeEach(^{
                    startStopModule = [[StartStopModule alloc] init];
                    [injector addModule:startStopModule];
                });

                it(@"module is configured", ^{
                    [[theValue(startStopModule.startStopObject.started) should] beYes];
                });

                it(@"module is unloaded", ^{
                    [injector removeModule:startStopModule];
                    [[theValue(startStopModule.startStopObject.started) should] beNo];
                });

                it(@"module is unloaded", ^{
                    [injector reset];
                    [[theValue(startStopModule.startStopObject.started) should] beNo];
                });

            });

        });

        SPEC_END