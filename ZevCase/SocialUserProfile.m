//
//  SocialUserProfile.m
//  Social
//
//  Created by Yu Li on 01/08/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//
// --- Headers --- ;
#import "SocialUserProfile.h"

// --- Defines --- ;
// SocialUserProfile Class ;
@implementation SocialUserProfile

// Properties ;
@synthesize name ;
@synthesize website ;
@synthesize bio ;
@synthesize email ;
@synthesize phone ;
@synthesize sex ;
@synthesize photos ;
@synthesize followers ;
@synthesize followings ;
@synthesize following ;
@synthesize photoPrivate ;

// Functions ;
#pragma mark - Shared Functions
+ ( id ) me
{
    __strong static SocialUserProfile*  sharedObject = nil ;
	static dispatch_once_t onceToken ;
    
	dispatch_once( &onceToken, ^{
        sharedObject = [ [ SocialUserProfile alloc ] init ] ;
	} ) ;
    
    return sharedObject ;
}

#pragma mark - SocialUserProfile
- ( id ) initWithDict : ( NSDictionary* ) _dict
{
    self = [ super init ] ;
    
    if( self )
    {
        // Set ;
        [ self setUserid : [ _dict objectForKey : @"user_id" ] ] ;
        [ self setUsername : [ _dict objectForKey : @"user_username" ] ] ;
        [ self setName : [ _dict objectForKey : @"user_name" ] ] ;
        [ self setAvatar : [ _dict objectForKey : @"user_avatar" ] ] ;
        [ self setWebsite : [ _dict objectForKey : @"user_website" ] ] ;
        [ self setBio : [ _dict objectForKey : @"user_bio" ] ] ;
        [ self setEmail : [ _dict objectForKey : @"user_email" ] ] ;
        [ self setPhone : [ _dict objectForKey : @"user_phone" ] ] ;
        [ self setSex : [ _dict objectForKey : @"user_sex" ] ] ;
        [ self setPhotos : [ [ _dict objectForKey :  @"user_photos" ] intValue ] ] ;
        [ self setFollowers : [ [ _dict objectForKey : @"user_followers" ] intValue ] ] ;
        [ self setFollowings : [ [ _dict objectForKey : @"user_followings" ] intValue ] ] ;
        [ self setFollowing : [ [ _dict objectForKey : @"user_following" ] boolValue ] ] ;
        [ self setPhotoPrivate : [ [ _dict objectForKey : @"user_photo_private" ] boolValue ] ] ;
    }
    
    return self ;
}

- ( void ) dealloc
{
    // Release ;
    [ self setName : nil ] ;
    [ self setWebsite : nil ] ;
    [ self setBio : nil ] ;
    [ self setEmail : nil ] ;
    [ self setPhone : nil ] ;
    [ self setSex : nil ] ;
    
}

@end