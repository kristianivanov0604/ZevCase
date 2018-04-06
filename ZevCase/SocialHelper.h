//
//  SocialHelper.h
//  Social
//
//  Created by Yu Li on 01/08/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//
// --- Headers --- ;
#import <Foundation/Foundation.h>

// --- Defines --- ;
// SocialHelper Class ;
@interface SocialHelper : NSObject

// Functions ;
+ ( NSString* ) timeElapsed : ( NSInteger ) _seconds ;
+ ( NSString* ) timeElapsedNotification : ( NSInteger ) _seconds ;

@end