//
//  SocialFollow.m
//  Social
//
//  Created by Yu Li on 01/08/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//
// --- Headers --- ;
#import "SocialFollow.h"

// --- Defines --- ;
// SocialFollow Class ;
@implementation SocialFollow

// Properties ;
@synthesize following ;

// Functions ;
#pragma mark - SocialFollow
- ( id ) initWithDict : ( NSDictionary* ) _dict
{
    self = [ super init ] ;
    
    if( self )
    {
        // Set ;
        [ self setUserid : [ _dict objectForKey : @"user_id" ] ] ;
        [ self setUsername : [ _dict objectForKey : @"user_username" ] ] ;
        [ self setAvatar : [ _dict objectForKey : @"user_avatar" ] ] ;
        [ self setFollowing : [ [ _dict objectForKey : @"following" ] boolValue ] ] ;
    }
    
    return self ;
}

- ( void ) dealloc
{
    // Release ;
    [ self setUserid : nil ] ;
    [ self setUsername : nil ] ;
    [ self setAvatar : nil ] ;
    
}

@end