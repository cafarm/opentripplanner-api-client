//
//  OTPPlannerError.h
//  OTPClient
//
//  Created by Mark Cafaro on 7/23/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTPPlannerError : NSObject

@property (strong, nonatomic) NSNumber *ID;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSNumber *noPath;

@end
