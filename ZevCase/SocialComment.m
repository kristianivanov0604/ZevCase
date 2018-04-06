//
//  SocialComment.m
//  Social
//
//  Created by Yu Li on 01/08/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//
// --- Headers --- ;
#import "SocialComment.h"
#import "SocialUser.h"

// --- Defines --- ;
// SocialComment Class ;
@implementation SocialComment

// Properties ;
@synthesize commentid ;
@synthesize comment ;
@synthesize date ;
@synthesize sending ;

// Functions ;
#pragma mark - Shared Functions
+ ( id ) comments : ( NSArray* ) _array
{
    NSMutableArray* array   = [ NSMutableArray array ] ;

    for( NSDictionary* dict in _array )
    {
        SocialComment*  comment = [ [ SocialComment alloc ] initWithDict : dict ]  ;
        
        // Add ;
        [ array addObject : comment ] ;
    }
    
    return array ;
}

#pragma mark - SocialComment
- ( id ) initWithDict : ( NSDictionary* ) _dict
{
    self = [ super init ] ;
    
    if( self )
    {
        // Set ;
        [ self setCommentid : [ _dict objectForKey : @"comment_id" ] ] ;
        [ self setUserid : [ _dict objectForKey : @"comment_user_id" ] ] ;
        [ self setUsername : [ _dict objectForKey : @"comment_user_username" ] ] ;
        [ self setAvatar : [ _dict objectForKey : @"comment_user_avatar" ] ] ;
        [ self setComment : [ _dict objectForKey : @"comment_text" ] ] ;
        [ self setDate : [ _dict objectForKey : @"comment_date" ] ] ;
        [ self setSending : NO ] ;
    }
    
    return self ;
}

- ( void ) dealloc
{
    // Release ;
    [ self setCommentid : nil ] ;
    [ self setUserid : nil ] ;
    [ self setUsername : nil ] ;
    [ self setAvatar : nil ] ;
    [ self setComment : nil ] ;
    [ self setDate : nil ] ;

}

@end