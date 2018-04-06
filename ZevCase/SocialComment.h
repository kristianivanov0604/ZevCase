//
//  SocialComment.h
//  Social
//
//  Created by Yu Li on 01/08/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//
// --- Headers --- ;
#import <Foundation/Foundation.h>
#import "SocialUser.h"

// --- Defines --- ;
// SocialComment Class ;
@interface SocialComment : SocialUser

// Properties ;
@property ( nonatomic, retain ) NSString*       commentid ;
@property ( nonatomic, retain ) NSString*       comment ;
@property ( nonatomic, retain ) NSString*       date ;
@property ( nonatomic )         BOOL            sending ;

// Functions ;
+ ( id ) comments : ( NSArray* ) _array ;
- ( id ) initWithDict : ( NSDictionary* ) _dict ;

@end