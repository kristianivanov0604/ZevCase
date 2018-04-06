//
//  SocialMoreCell.m
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import "SocialMoreCell.h"

// --- Defines --- ;
// SocialMoreCell Class ;
@implementation SocialMoreCell

// Properties ;
@synthesize delegate ;

// Functions ;
#pragma mark - Shared Funtions
+ ( SocialMoreCell* ) sharedCell
{
    NSArray*            array   = [ [ NSBundle mainBundle ] loadNibNamed : @"SocialMoreCell" owner : nil options : nil ] ;
    SocialMoreCell*     view    = [ array objectAtIndex : 0 ] ;
    
    return view ;
}

#pragma mark - SocialMoreCell
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
    NSMutableArray* array   = [ NSMutableArray array ] ;
    
    for( NSInteger index = 1 ; index <= 8 ; index ++ )
    {
        UIImage*    image   = [ UIImage imageNamed : [ NSString stringWithFormat : @"feedstate-spinner-frame%02d.png", index ] ] ;
        
        // Add ;
        [ array addObject : image ] ;
    }
    

    // Animation ;
    [ imgForAnimation setAnimationDuration : 1 ] ;
    [ imgForAnimation setAnimationImages : array ] ;
}

- ( void ) layoutSubviews
{
    [ super layoutSubviews ] ;
}

- ( void ) setSelected : ( BOOL ) _selected animated : ( BOOL ) _animated
{
    
}

- ( void ) startAnimation
{
    [ imgForAnimation startAnimating ] ;
}

- ( void ) stopAnimation
{
    [ imgForAnimation stopAnimating ] ;
}

@end