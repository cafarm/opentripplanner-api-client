//
//  OTPMappingProvider.h
//  OTPClient
//
//  Created by Mark Cafaro on 7/22/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <RestKit/RestKit.h>

@interface OTPMappingProvider : RKObjectMappingProvider

- (RKObjectMapping *)responseObjectMapping;

- (RKObjectMapping *)tripPlanObjectMapping;

- (RKObjectMapping *)itineraryObjectMapping;

@end
