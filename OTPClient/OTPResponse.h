//
//  OTPResponse.h
//  OTPClient
//
//  Created by Mark Cafaro on 7/22/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OTPTripPlan.h"

@interface OTPResponse : NSObject

@property (strong, nonatomic) OTPTripPlan *tripPlan;

@end
