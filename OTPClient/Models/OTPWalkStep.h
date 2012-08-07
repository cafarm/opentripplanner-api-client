//
//  OTPWalkStep.h
//  OTPClient
//
//  Created by Mark Cafaro on 7/23/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OTPLeg;

@interface OTPWalkStep : NSObject

@property (strong, nonatomic) NSNumber *distance;
@property (strong, nonatomic) NSString *relativeDirection;
@property (strong, nonatomic) NSString *streetName;
@property (strong, nonatomic) NSString *absoluteDirection;
@property (strong, nonatomic) NSString *exit;
@property (strong, nonatomic) NSNumber *stayOn;
@property (strong, nonatomic) NSNumber *bogusName;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSNumber *latitude;

@property (weak, nonatomic) OTPLeg *leg;

@end
