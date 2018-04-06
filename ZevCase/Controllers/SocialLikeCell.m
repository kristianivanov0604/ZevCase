//
//  SocialLike.m
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import <QuartzCore/QuartzCore.h>

#import "SocialLikeCell.h"
#import "SocialLike.h"

#import "UIImageView+AFNetworking.h"

// --- Defines --- ;
// SocialLikeCell Class ;
@implementation SocialLikeCell

// Properties ;
@synthesize like ;

// Functions ;
#pragma mark - Shared Funtions
+ ( SocialLikeCell* ) sharedCell
{
    NSArray*            array   = [ [ NSBundle mainBundle ] loadNibNamed : @"SocialLikeCell" owner : nil options : nil ] ;
    SocialLikeCell*     cell    = [ array objectAtIndex : 0 ] ;
    
    return cell ;
}

#pragma mark - SocialLikeCell
- ( id ) initWithStyle : ( UITableViewCellStyle ) _style reuseIdentifier : ( NSString* ) _reuseIdentifier
{
    self = [ super initWithStyle : _style reuseIdentifier : _reuseIdentifier ] ;
    
    if( self )
    {
        
    }
    
    return self ;
}

- ( void ) awakeFromNib
{
    [ [ imgForAvatar layer ] setMasksToBounds : YES ] ;
    [ [ imgForAvatar layer ] setBorderColor : [ UIColor grayColor ].CGColor ] ;
    [ [ imgForAvatar layer ] setBorderWidth : 0.5f ] ;
    [ [ imgForAvatar layer ] setCornerRadius : 3.0f ] ;
}

- ( void ) layoutSubviews
{
    [ super layoutSubviews ] ;
}

- ( void ) setSelected : ( BOOL ) _selected animated : ( BOOL ) _animated
{
    
}

- ( void ) setLike : ( SocialLike* ) _like
{
    // Set ;
    
    like    = _like ;
    
    // UI ;
    [ imgForAvatar setImageWithURL : [ NSURL URLWithString : [ like avatar ] ] placeholderImage : [ UIImage imageNamed : @"anonymousUser.png" ] ] ;
    [ lblForUsername setText : [ like username ] ] ;
}

@end