//
//  OTPResponse.h
//  OTPClient
//
//  Created by Mark Cafaro on 7/22/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OTPRequestParameters;
@class OTPTripPlan;
@class OTPPlannerError;

@interface OTPResponse : NSObject

@property (strong, nonatomic) OTPRequestParameters *requestParameters;
@property (strong, nonatomic) OTPTripPlan *tripPlan;
@property (strong, nonatomic) OTPPlannerError *plannerError;

@end
