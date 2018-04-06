//
//  SocialUser.m
//  Social
//
//  Created by Yu Li on 01/08/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//
// --- Headers --- ;
#import "SocialUser.h"

// --- Defines --- ;
// SocialUser Class ;
@implementation SocialUser

// Properties ;
@synthesize userid ;
@synthesize username ;
@synthesize avatar ;

// Functions ;
#pragma mark - Shared Functions
+ ( id ) me
{
    __strong static SocialUser*     sharedObject = nil ;
	static dispatch_once_t onceToken ;
    
	dispatch_once( &onceToken, ^{
        sharedObject = [ [ SocialUser alloc ] init ] ;
	} ) ;
    
    return sharedObject ;
}

#pragma mark - SocialUser
- ( id ) initWithDict : ( NSDictionary* ) _dict
{
    self = [ super init ] ;
    
    if( self )
    {
        // Set ;
        [ self setUserid    : [ _dict objectForKey : @"user_id" ] ] ;
        [ self setUsername  : [ _dict objectForKey : @"user_username" ] ] ;
        [ self setName      : [ _dict objectForKey : @"user_name" ] ] ;
        [ self setAvatar    : [ _dict objectForKey : @"user_avatar" ] ] ;
        [ self setEmail     : [ _dict objectForKey : @"user_email" ] ] ;
        [ self setPhone     : [ _dict objectForKey : @"user_phone" ] ] ;
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