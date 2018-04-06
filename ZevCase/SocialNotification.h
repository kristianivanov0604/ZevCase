//
//  SocialNotification.h
//  ZevCase
//
//  Created by Yu Li on 1/7/14.
//  Copyright (c) 2014 Yu Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialUser.h"

@interface SocialNotification : SocialUser

@property                     NSInteger date;
@property                     BOOL      following;

// Functions ;
- ( id ) initWithDict : ( NSDictionary* ) _dict ;

@end
