//
//  SocialLike.m
//  Social
//
//  Created by Yu Li on 01/08/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//
// --- Headers --- ;
#import "SocialLike.h"

// --- Defines --- ;
// SocialLike Class ;
@implementation SocialLike

// Properties ;

// Functions ;
#pragma mark - Shared Functions
+ ( id ) user : ( SocialUser* ) _user
{
    SocialLike* like    = [ [ SocialLike alloc ] init ] ;
    
    [ like setUserid : [ _user userid ] ] ;
    [ like setUsername : [ _user username] ] ;
    [ like setAvatar : [ _user avatar ] ] ;
    
    return like ;
}

#pragma mark - SocialLike
- ( id ) initWithDict : ( NSDictionary* ) _dict
{
    self = [ super init ] ;
    
    if( self )
    {
        // Set ;
        [ self setUserid : [ _dict objectForKey : @"like_user_id" ] ] ;
        [ self setUsername : [ _dict objectForKey : @"like_user_username" ] ] ;
        [ self setAvatar : [ _dict objectForKey : @"like_user_avatar" ] ] ;
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