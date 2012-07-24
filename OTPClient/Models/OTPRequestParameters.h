//
//  OTPRequestParameters.h
//  OTPClient
//
//  Created by Mark Cafaro on 7/23/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTPRequestParameters : NSObject

@property (strong, nonatomic) NSString *fromPlace;
@property (strong, nonatomic) NSString *toPlace;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *arriveBy;
@property (strong, nonatomic) NSString *wheelchair;
@property (strong, nonatomic) NSString *maxWalkDistance;
@property (strong, nonatomic) NSString *mode;
@property (strong, nonatomic) NSString *min;
@property (strong, nonatomic) NSString *minTransferTime;
@property (strong, nonatomic) NSString *numItineraries;
@property (strong, nonatomic) NSString *transferPenalty;
@property (strong, nonatomic) NSString *maxTransfers;

@end
