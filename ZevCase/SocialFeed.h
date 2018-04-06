//
//  SocialFeed.h
//  Social
//
//  Created by Yu Li on 01/08/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//
// --- Headers --- ;
#import <Foundation/Foundation.h>
#import "SocialUser.h"

// --- Defines --- ;
// SocialFeed Class ;
@interface SocialFeed : SocialUser

// Properties ;
@property ( nonatomic, retain ) NSString*       postid ;
@property ( nonatomic, retain ) NSString*       photo ;
@property ( nonatomic, retain ) NSString*       name ;
@property ( nonatomic )         NSInteger       likes ;
@property ( nonatomic )         BOOL            liked ;
@property ( nonatomic )         NSInteger       comments ;
@property ( nonatomic )         NSInteger       date ;
@property ( nonatomic, retain ) NSMutableArray* commentArray ;
@property ( nonatomic, retain ) NSString*       userBio ;

// Functions ;
- ( id ) initWithDict : ( NSDictionary* ) _dict ;

@end