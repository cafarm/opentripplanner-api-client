//
//  OTPObjectManagerTest.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/25/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>

#import "OTPObjectManager.h"
#import "OTPTripPlan.h"

@interface OTPObjectManagerTest : SenTestCase
@end

@implementation OTPObjectManagerTest
{
    BOOL done;
}

- (void)setUp
{
    [RKTestFactory setUp];
    done = NO;
}

- (void)tearDown
{
    [RKTestFactory tearDown];
}

- (BOOL)waitForCompletion:(NSTimeInterval)timeoutSecs {
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
    
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if([timeoutDate timeIntervalSinceNow] < 0.0) {
            break;
        }
    } while (!done);
    
    return done;
}

- (void)testLoadingOfTripPlan
{
    OTPObjectManager *objectManager = [[OTPObjectManager alloc] initWithBaseURL:RKTestFactory.baseURL];
//    OTPObjectManager *objectManager = [[OTPObjectManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:8080/opentripplanner-api-webapp"]];
    
    CLLocationCoordinate2D from;
    from.latitude = 47.656771;
    from.longitude = -122.301599;
    
    CLLocationCoordinate2D to;
    to.latitude = 47.530123;
    to.longitude = -122.302415;
    
    __block OTPTripPlan *loadedTripPlan;
    __block NSError *loadedError;
    [objectManager loadTripPlanFrom:from to:to withCompletion:^(OTPTripPlan *tripPlan, NSError *error) {
        loadedTripPlan = tripPlan;
        loadedError = error;
        done = YES;
    }];
        
    STAssertTrue([self waitForCompletion:90.0], @"Failed to get any results in time");
    STAssertNil(loadedError, nil);
    STAssertNotNil(loadedTripPlan.itineraries, nil);
}

// TODO: error testing

@end
