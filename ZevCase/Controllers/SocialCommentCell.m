//
//  SocialCommentCell.m
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import "SocialCommentCell.h"
#import "SocialComment.h"

#import "GlobalData.h"
#import "UIImageView+AFNetworking.h"

// --- Defines --- ;
// SocialCommentCell Class ;
@interface SocialCommentCell ()
{
    CGPoint     pointForStart ;
    float       distance ;
    BOOL        state ;
}

@end

@implementation SocialCommentCell

// Properties ;
@synthesize delegate ;
@synthesize comment ;

// Functions ;
#pragma mark - Shared Funtions
+ ( SocialCommentCell* ) sharedCell
{
    NSArray*            array   = [ [ NSBundle mainBundle ] loadNibNamed : @"SocialCommentCell" owner : nil options : nil ] ;
    SocialCommentCell*  cell    = [ array objectAtIndex : 0 ] ;
    
    return cell ;
}

#pragma mark - SocialCommentCell
- ( id ) initWithStyle : ( UITableViewCellStyle ) _style reuseIdentifier : ( NSString* ) _reuseIdentifier
{
    self = [ super initWithStyle : _style reuseIdentifier : _reuseIdentifier ] ;
    
    if( self )
    {
        
    }
    
    return self ;
}

- ( void ) layoutSubviews
{
    [ super layoutSubviews ] ;
}

- ( void ) setSelected : ( BOOL ) _selected animated : ( BOOL ) _animated
{
    
}

- ( void ) setComment : ( SocialComment* ) _comment
{
    // Release ;

    
    comment = _comment ;

    
    // UI ;
    [ viewForComment setFrame : CGRectMake( 0, 0, viewForComment.frame.size.width, viewForComment.frame.size.height ) ] ;
    
    [ imgForAvatar setImageWithURL : [ NSURL URLWithString : [ comment avatar ] ] placeholderImage : [ UIImage imageNamed : @"anonymousUser.png" ] ] ;
    [GlobalMethods setRoundView:imgForAvatar borderColor:Nil];

    [ lblForUser setText : [ comment username ] ] ;
    [ lblForComment setText : [ comment comment ] ] ;
    
    if( [ comment sending ] )
    {
        [ indicatorForComment startAnimating ] ;
    }
    else
    {
        [ indicatorForComment stopAnimating ] ;
    }
}

- ( void ) touchesBegan : ( NSSet* ) _touches withEvent : ( UIEvent* ) _event
{
    UITouch*    touch   = [ _touches anyObject ] ;
    CGPoint     point   = [ touch locationInView : self ] ;
    
    pointForStart   = point ;
    distance        = pointForStart.x - viewForComment.frame.origin.x ;
    
    if( [ self.delegate respondsToSelector : @selector( didTouchesBegan: ) ] )
    {
        [ self.delegate performSelector : @selector( didTouchesBegan: ) withObject : [ self comment ] ] ;
    }
}

- ( void ) touchesMoved : ( NSSet* ) _touches withEvent : ( UIEvent* ) _event
{
    UITouch*    touch   = [ _touches anyObject ] ;
    CGPoint     point   = [ touch locationInView : self ] ;
    CGRect      frame   = [ viewForComment frame ] ;
    
    if( state )
    {
        if( point.x - pointForStart.x > 0 )
        {
            return ;
        }
    }
    else
    {
        if( point.x - pointForStart.x < 0 )
        {
            return ;
        }
    }
    
    // Frame ;
    frame.origin.x  = point.x - distance ;
    
    // Set ;
    [ viewForComment setFrame : frame ] ;
}

- ( void ) touchesEnded : ( NSSet* ) _touches withEvent : ( UIEvent* ) _event
{
    UITouch*    touch   = [ _touches anyObject ] ;
    CGPoint     point   = [ touch locationInView : self ] ;
    CGRect      frame   = [ viewForComment frame ] ;
    
    if( state )
    {
        if( point.x - pointForStart.x > 0 )
        {
            return ;
        }
        
        state   = NO ;
        frame.origin.x  = 0 ;
    }
    else
    {
        if( point.x - pointForStart.x < 0 )
        {
            return ;
        }
        
        state   = YES ;
        frame.origin.x  = 114 ;
    }
    
    // Set ;
    [ UIView beginAnimations : nil context : nil ] ;
    [ UIView setAnimationCurve : UIViewAnimationCurveEaseInOut ] ;
    [ UIView setAnimationDelay : 0 ] ;
    [ UIView setAnimationDuration : 0.25 ] ;
    
    [ viewForComment setFrame : frame ] ;

    [ UIView commitAnimations ] ;
    
    if( [ self.delegate respondsToSelector : @selector( didTouchesEnded: ) ] )
    {
        [ self.delegate performSelector : @selector( didTouchesEnded: ) withObject : [ self comment ] ] ;
    }
}

- ( void ) touchesCancelled : ( NSSet* ) _touches withEvent : ( UIEvent* ) _event
{
    [ self touchesEnded : _touches withEvent : _event ] ;
}

@end