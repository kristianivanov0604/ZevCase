//
//  SocialNotification.m
//  ZevCase
//
//  Created by Yu Li on 1/7/14.
//  Copyright (c) 2014 Yu Li. All rights reserved.
//

#import "SocialNotification.h"
#import "SocialUser.h"

@implementation SocialNotification
@synthesize date;
@synthesize following;

#pragma mark - SocialNotification

- ( id ) initWithDict : ( NSDictionary* ) _dict
{
    self = [ super init ] ;
    
    if( self )
    {
        // Set ;
        [ self setUsername : [ _dict objectForKey : @"notification_user_username" ] ] ;
        [ self setAvatar : [ _dict objectForKey : @"notification_user_avatar" ] ] ;
        [ self setFollowing : [[_dict objectForKey:@"notification_following"] boolValue] ];
        [ self setDate : [[_dict objectForKey:@"notification_date"] intValue] ];
    }
    
    return self ;
}

- ( void ) dealloc
{
    // Release ;
    [ self setUsername : nil ] ;
    [ self setAvatar : nil ] ;
}


@end
