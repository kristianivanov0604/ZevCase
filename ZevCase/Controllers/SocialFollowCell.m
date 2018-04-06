//
//  SocialFollowCell.m
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import <QuartzCore/QuartzCore.h>

#import "SocialFollowCell.h"
#import "SocialFollow.h"

#import "UIImageView+AFNetworking.h"

// --- Defines --- ;
// SocialFollowCell Class ;
@implementation SocialFollowCell

// Properties ;
@synthesize delegate ;
@synthesize follow ;

// Functions ;
#pragma mark - Shared Funtions
+ ( SocialFollowCell* ) sharedCell
{
    NSArray*            array   = [ [ NSBundle mainBundle ] loadNibNamed : @"SocialFollowCell" owner : nil options : nil ] ;
    SocialFollowCell*   cell    = [ array objectAtIndex : 0 ] ;
    
    return cell ;
}

#pragma mark - SocialFollowCell
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

- ( void ) setSelected : ( BOOL ) _selected animated : ( BOOL ) _animated
{
    
}

- ( void ) setFollow : ( SocialFollow* ) _follow
{
    // Set ;
    
    follow = _follow ;

    
    // UI ;
    [ imgForAvatar setImageWithURL : [ NSURL URLWithString : [ follow avatar ] ] placeholderImage : [ UIImage imageNamed : @"anonymousUser.png" ] ] ;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    [imgForAvatar setUserInteractionEnabled:YES];
    tapGesture.numberOfTapsRequired = 1;
    [imgForAvatar addGestureRecognizer:tapGesture];
    
    [ lblForUsername setText : [ follow username ] ] ;
    
    if( [ follow following ] )
    {
        [ btnForFollow setTitle : @"Following" forState : UIControlStateNormal ] ;
    }
    else
    {

        [ btnForFollow setTitle : @"Follow" forState : UIControlStateNormal ] ;
    }
}

- (void) actionTap : (id)_sender{
    
    if( [ delegate respondsToSelector : @selector( didSelectedUser: ) ] )
    {
        [ delegate performSelector : @selector( didSelectedUser: ) withObject : [ self follow ] ] ;
    }
}

- ( IBAction ) onBtnFollow : ( id ) _sender
{
    
    
    if( [ self.delegate respondsToSelector : @selector( didFollow: ) ] )
    {
        [ self.delegate performSelector : @selector( didFollow: ) withObject : [ self follow ] ] ;
    }
}

@end