//
//  SocialUserProfile.h
//  Social
//
//  Created by Yu Li on 01/08/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//
// --- Headers --- ;
#import <Foundation/Foundation.h>

#import "SocialUser.h"

// --- Defines --- ;
// SocialUserProfile Class ;
@interface SocialUserProfile : SocialUser

// Properties ;
//@property ( nonatomic, retain ) NSString*       name ;
@property ( nonatomic, retain ) NSString*       website ;
@property ( nonatomic, retain ) NSString*       bio ;
//@property ( nonatomic, retain ) NSString*       email ;
//@property ( nonatomic, retain ) NSString*       phone ;
@property ( nonatomic, retain ) NSString*       sex ;
@property ( nonatomic )         NSInteger       photos ;
@property ( nonatomic )         NSInteger       followers ;
@property ( nonatomic )         NSInteger       followings ;
@property ( nonatomic )         BOOL            following ;
@property ( nonatomic )         BOOL            photoPrivate ;

// Functions ;
+ ( id ) me ;
- ( id ) initWithDict : ( NSDictionary* ) _dict ;

@end