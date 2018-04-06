//
//  SocialUser.h
//  Social
//
//  Created by Yu Li on 01/08/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//
// --- Headers --- ;
#import <Foundation/Foundation.h>

// --- Defines --- ;
// SocialUser Class ;
@interface SocialUser : NSObject

// Properties ;
@property ( nonatomic, retain ) NSString*       userid ;
@property ( nonatomic, retain ) NSString*       username ;
@property ( nonatomic, retain ) NSString*       name ;
@property ( nonatomic, retain ) NSString*       avatar ;
@property ( nonatomic, retain ) NSString*       email ;
@property ( nonatomic, retain ) NSString*       phone ;

// Functions ;
+ ( id ) me ;
- ( id ) initWithDict : ( NSDictionary* ) _dict ;

@end