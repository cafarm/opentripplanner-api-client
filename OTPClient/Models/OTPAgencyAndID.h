//
//  OTPAgencyAndID.h
//  OTPClient
//
//  Created by Mark Cafaro on 7/23/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OTPPlace;

@interface OTPAgencyAndID : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *agencyID;

@property (weak, nonatomic) OTPPlace *place;

@end
