//
//  SocialFeed.m
//  Social
//
//  Created by Yu Li on 01/08/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//
// --- Headers --- ;
#import "SocialFeed.h"
#import "SocialComment.h"

// --- Defines --- ;
// SocialFeed Class ;
@implementation SocialFeed

// Properties ;
@synthesize postid ;
@synthesize photo ;
@synthesize likes ;
@synthesize liked ;
@synthesize comments ;
@synthesize date ;
@synthesize commentArray ;
@synthesize name;

// Functions ;
#pragma mark - SocialFeed
- ( id ) initWithDict : ( NSDictionary* ) _dict
{
    self = [ super init ] ;
    
    if( self )
    {
        // Post ;
        [ self setPostid : [ _dict objectForKey : @"post_id" ] ] ;
        [ self setUserid : [ _dict objectForKey : @"post_user_id" ] ] ;
        [ self setUsername : [ _dict objectForKey : @"post_user_username" ] ] ;
        [ self setAvatar : [ _dict objectForKey : @"post_user_avatar" ] ] ;
        [ self setPhoto : [ _dict objectForKey : @"post_photo_url" ] ] ;
        [ self setName  : [ _dict objectForKey : @"post_name" ] ] ;
        [ self setLikes : [ [ _dict objectForKey : @"post_likes" ] intValue ] ] ;
        [ self setLiked : [ [ _dict objectForKey : @"post_liked" ] boolValue ] ] ;
        [ self setComments : [ [ _dict objectForKey : @"post_comments" ] intValue ] ] ;
        [ self setDate : [ [ _dict objectForKey : @"post_date" ] intValue ] ] ;
        [ self setCommentArray : [ SocialComment comments : [ _dict objectForKey : @"comments" ] ] ] ;
        [ self setUserBio: [ _dict objectForKey : @"post_user_bio" ] ] ;
    }
    
    return self ;
}

- ( void ) dealloc
{
    // Release ;
    [ self setPostid : nil ] ;
    [ self setUserid : nil ] ;
    [ self setUsername : nil ] ;
    [ self setAvatar : nil ] ;
    [ self setPhoto : nil ] ;
    [ self setName : nil ] ;

}

@end