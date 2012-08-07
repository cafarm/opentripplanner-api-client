//
//  OTPPlace.h
//  OTPClient
//
//  Created by Mark Cafaro on 7/23/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OTPAgencyAndID;
@class OTPLeg;

@interface OTPPlace : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) OTPAgencyAndID *stopID;
@property (strong, nonatomic) NSString *stopCode;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *arrivalAsTimeInterval;
@property (strong, nonatomic) NSDate *arrival;
@property (strong, nonatomic) NSNumber *depatureAsTimeInterval;
@property (strong, nonatomic) NSDate *departure;

@property (weak, nonatomic) OTPLeg *leg;

@end
