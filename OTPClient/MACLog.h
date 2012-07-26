//
//  MACLog.h
//  OTPClient
//
//  Created by Mark Cafaro on 7/26/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#ifndef OTPClient_MACLog_h
#define OTPClient_MACLog_h

// DLog will output like NSLog only when the DEBUG variable is set
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

// ALog will always output like NSLog
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

// ULog will show the UIAlertView only when the DEBUG variable is set
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

#endif
