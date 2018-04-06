//
//  SocialHelper.m
//  Social
//
//  Created by Yu Li on 01/08/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//
// --- Headers --- ;
#import "SocialHelper.h"

// --- Defines --- ;
// SocialHelper Class ;
@implementation SocialHelper

// Functions ;
#pragma mark - SocialHelper
+ ( NSString* ) timeElapsed : ( NSInteger ) _seconds
{
    NSInteger   index   = 0 ;
    NSInteger   unit    = 0 ;
    NSInteger   units[] = { 1, 60, 3600, 86400, 604800 } ;
    NSArray*    symbols = [ NSArray arrayWithObjects : @"s", @"m", @"h", @"d", @"w", nil ] ;
    
    for( index = 0 ; index < 5 ; index ++ )
    {
        if( _seconds < units[ index ] )
        {
            break ;
        }
    }
    
    unit = floor( _seconds / units[ index - 1 ] ) ;
    return [ NSString stringWithFormat : @"%d%@", unit, [ symbols objectAtIndex : index ? index - 1 : 0 ] ] ;
}

+ ( NSString* ) timeElapsedNotification : ( NSInteger ) _seconds
{
    NSInteger   index   = 0 ;
    NSInteger   unit    = 0 ;
    NSInteger   units[] = { 1, 60, 3600, 86400, 604800 } ;
    NSArray*    symbols = [ NSArray arrayWithObjects : @"seconds", @"minutes", @"hours", @"days", @"weeks", nil ] ;
    
    for( index = 0 ; index < 5 ; index ++ )
    {
        if( _seconds < units[ index ] )
        {
            break ;
        }
    }
    
    unit = floor( _seconds / units[ index - 1 ] ) ;
    return [ NSString stringWithFormat : @"%d %@", unit, [ symbols objectAtIndex : index ? index - 1 : 0 ] ] ;
}

@end