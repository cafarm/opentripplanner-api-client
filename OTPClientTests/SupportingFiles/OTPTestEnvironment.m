//
//  OTPTestEnvironment.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/22/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import "OTPTestEnvironment.h"

@implementation RKTestFactory (OTPClient)

+ (void)didInitialize
{
    [RKTestFixture setFixtureBundle:[NSBundle bundleWithIdentifier:@"com.sevenoeight.OTPClientTests"]];
}

@end
