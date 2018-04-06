//
//  SocialFollow.h
//  Social
//
//  Created by Yu Li on 01/08/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//
// --- Headers --- ;
#import <Foundation/Foundation.h>
#import "SocialUser.h"

// --- Defines --- ;
// SocialFollow Class ;
@interface SocialFollow : SocialUser

// Properties ;
@property ( nonatomic ) BOOL    following ;

// Functions ;
- ( id ) initWithDict : ( NSDictionary* ) _dict ;

@end