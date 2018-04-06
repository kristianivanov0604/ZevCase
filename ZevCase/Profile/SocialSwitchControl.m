//
//  SocialSwitchControl.m
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import <QuartzCore/QuartzCore.h>
#import "SocialSwitchControl.h"

// --- Defines --- ;
#define WIDTH               79.0f
#define HEIGHT              29.0f
#define BACK_WIDTH          79.0f
#define BUTTON_DIAM         29.0f
#define HORZ_PADDING        0.0     // Padding between the button and the edge of the switch.
#define TAP_SENSITIVITY     25.0    // Margin of error to detect if the switch was tapped or swiped.

// SocialSwitchControl Class ;
@implementation SocialSwitchControl

// Functions ;
- ( id ) initWithFrame : ( CGRect ) _frame
{
    self = [ super initWithFrame : CGRectMake( _frame.origin.x, _frame.origin.y, WIDTH, HEIGHT ) ] ;
    
    if( self )
    {
        self.layer.masksToBounds = YES ;
        
        // Background For Off ;
        imgForBackground_Off = [ [ UIImageView alloc ] initWithFrame : CGRectMake( 0, 0, BACK_WIDTH, HEIGHT ) ] ;
        [ imgForBackground_Off setImage : [ UIImage imageNamed : @"cell-toggle-background-off.png" ] ] ;
        [ self addSubview : imgForBackground_Off ] ;

        // Background For On ;
        imgForBackground_On    = [ [ UIImageView alloc ] initWithFrame : CGRectMake( -BACK_WIDTH + BUTTON_DIAM, 0, BACK_WIDTH, HEIGHT ) ] ;
        [ imgForBackground_On setImage : [ [ UIImage imageNamed : @"cell-toggle-background-on.png" ] resizableImageWithCapInsets : UIEdgeInsetsMake( 14.5, 4.5, 14.5f, 4.5f ) ] ] ;
        [ self addSubview : imgForBackground_On ] ;

        // View For Button ;
        viewForBtn  = [ [ UIView alloc ] initWithFrame : CGRectMake( HORZ_PADDING, 0, BUTTON_DIAM, BUTTON_DIAM ) ] ;
        [ viewForBtn setBackgroundColor : [ UIColor clearColor ] ] ;
        [ self addSubview : viewForBtn ] ;
        
        // Button ;
        imgForButton    = [ [ UIImageView alloc ] initWithFrame : CGRectMake( HORZ_PADDING, 0, BUTTON_DIAM, BUTTON_DIAM ) ] ;
        [ viewForBtn addSubview : imgForButton ] ;
        [ imgForButton setImage : [ UIImage imageNamed : @"cell-toggle-toggle.png" ] ] ;
        
        // Label For Off ;
        lblForOff   = [ [ UILabel alloc ] initWithFrame : CGRectMake( BUTTON_DIAM, 0, BACK_WIDTH - BUTTON_DIAM, BUTTON_DIAM ) ] ;
        [ viewForBtn addSubview : lblForOff ] ;
        [ lblForOff setText : @"Off" ] ;
        [ lblForOff setBackgroundColor : [ UIColor clearColor ] ] ;
        [ lblForOff setTextColor : [ UIColor whiteColor ] ] ;
        [ lblForOff setTextAlignment : NSTextAlignmentCenter ] ;
        
        // Label For On ;
        lblForOn   = [ [ UILabel alloc ] initWithFrame : CGRectMake( - BACK_WIDTH + BUTTON_DIAM, 0, BACK_WIDTH - BUTTON_DIAM, BUTTON_DIAM ) ] ;
        [ viewForBtn addSubview : lblForOn ] ;
        [ lblForOn setText : @"On" ] ;
        [ lblForOn setBackgroundColor : [ UIColor clearColor ] ] ;
        [ lblForOn setTextColor : [ UIColor whiteColor ] ] ;
        [ lblForOn setTextAlignment : NSTextAlignmentCenter ] ;
        
        isOn = YES ;
    }
    
    return self ;
}

- ( id ) initWithCoder : ( NSCoder* ) _coder
{
    self = [ super initWithCoder : ( NSCoder* ) _coder ] ;
    
    if( self )
    {
        self.layer.masksToBounds = YES ;
        
        // Background For Off ;
        imgForBackground_Off = [ [ UIImageView alloc ] initWithFrame : CGRectMake( 0, 0, BACK_WIDTH, HEIGHT ) ] ;
        [ imgForBackground_Off setImage : [ UIImage imageNamed : @"cell-toggle-background-off.png" ] ] ;
        [ self addSubview : imgForBackground_Off ] ;
        
        // Background For On ;
        imgForBackground_On    = [ [ UIImageView alloc ] initWithFrame : CGRectMake( -BACK_WIDTH + BUTTON_DIAM, 0, BACK_WIDTH, HEIGHT ) ] ;
        [ imgForBackground_On setImage : [ [ UIImage imageNamed : @"cell-toggle-background-on.png" ] resizableImageWithCapInsets : UIEdgeInsetsMake( 14.5, 4.5, 14.5f, 4.5f ) ] ] ;
        [ imgForBackground_On setAlpha : 0.0f ] ;
        [ self addSubview : imgForBackground_On ] ;
        
        // View For Button ;
        viewForBtn  = [ [ UIView alloc ] initWithFrame : CGRectMake( HORZ_PADDING, 0, BUTTON_DIAM, BUTTON_DIAM ) ] ;
        [ viewForBtn setBackgroundColor : [ UIColor clearColor ] ] ;
        [ self addSubview : viewForBtn ] ;
        
        // Button ;
        imgForButton    = [ [ UIImageView alloc ] initWithFrame : CGRectMake( HORZ_PADDING, 0, BUTTON_DIAM, BUTTON_DIAM ) ] ;
        [ viewForBtn addSubview : imgForButton ] ;
        [ imgForButton setImage : [ UIImage imageNamed : @"cell-toggle-toggle.png" ] ] ;
        
        // Label For Off ;
        lblForOff   = [ [ UILabel alloc ] initWithFrame : CGRectMake( BUTTON_DIAM, 0, BACK_WIDTH - BUTTON_DIAM, BUTTON_DIAM ) ] ;
        
        [ lblForOff setText : @"Off" ] ;
        [ lblForOff setBackgroundColor : [ UIColor clearColor ] ] ;
        [ lblForOff setFont : [ UIFont fontWithName : @"FreightSans BoldSC" size : 16.0f ] ] ;
        [ lblForOff setTextColor : [ UIColor whiteColor ] ] ;
        [ lblForOff setTextAlignment : NSTextAlignmentCenter ] ;
        
        [ viewForBtn addSubview : lblForOff ] ;
        
        // Label For On ;
        lblForOn   = [ [ UILabel alloc ] initWithFrame : CGRectMake( - BACK_WIDTH + BUTTON_DIAM, 0, BACK_WIDTH - BUTTON_DIAM, BUTTON_DIAM ) ] ;
        
        [ lblForOn setText : @"On" ] ;
        [ lblForOn setBackgroundColor : [ UIColor clearColor ] ] ;
        [ lblForOn setFont : [ UIFont fontWithName : @"FreightSans BoldSC" size : 16.0f ] ] ;
        [ lblForOn setTextColor : [ UIColor whiteColor ] ] ;
        [ lblForOn setTextAlignment : NSTextAlignmentCenter ] ;
        
        [ viewForBtn addSubview : lblForOn ] ;
        
        isOn = YES ;
    }
    
    return self ;
}

- ( void ) dealloc
{
    // Release ;
    [ lblForOn removeFromSuperview ] ;
    
    [ lblForOff removeFromSuperview ] ;
    
    [ imgForButton removeFromSuperview ] ;
    
    [ viewForBtn removeFromSuperview ] ;
    
    [ imgForBackground_On removeFromSuperview ] ;

    [ imgForBackground_Off removeFromSuperview ] ;
     
}

- ( void ) setOn : ( BOOL ) _on animated : ( BOOL ) _animated
{
    CGRect newBackFrame ;
    CGRect newButtonFrame ;
    
    isOn = _on ;
    
    if( _on )
    {
        newBackFrame    = CGRectMake( 0, 0, BACK_WIDTH, HEIGHT ) ;
        newButtonFrame  = CGRectMake( WIDTH - BUTTON_DIAM - HORZ_PADDING, 0, BUTTON_DIAM, BUTTON_DIAM ) ;
    }
    else
    {
        newBackFrame    = CGRectMake( -( WIDTH-BUTTON_DIAM ), 0, BACK_WIDTH, HEIGHT ) ;
        newButtonFrame  = CGRectMake( HORZ_PADDING, 0, BUTTON_DIAM, BUTTON_DIAM ) ;
    }
    
    if( _animated )
    {
        [ UIView beginAnimations : nil context : nil ] ;
        [ UIView setAnimationCurve : UIViewAnimationCurveEaseInOut ] ;
        [ UIView setAnimationDelay : 0 ] ;
        [ UIView setAnimationDuration : 0.23 ] ;
        
        [ viewForBtn setFrame : newButtonFrame ] ;
        
        [ imgForBackground_On setAlpha : ( ( newButtonFrame.origin.x ) / ( BACK_WIDTH - BUTTON_DIAM ) ) ] ;
        [ imgForBackground_On setFrame : CGRectMake( 0, 0, newButtonFrame.origin.x + BUTTON_DIAM, BUTTON_DIAM ) ] ;
        
        [ UIView commitAnimations ] ;
    }
    else
    {
        [ viewForBtn setFrame : newButtonFrame ] ;
        
        [ imgForBackground_On setAlpha : ( ( newButtonFrame.origin.x ) / ( BACK_WIDTH - BUTTON_DIAM ) ) ] ;
        [ imgForBackground_On setFrame : CGRectMake( 0, 0, newButtonFrame.origin.x + BUTTON_DIAM, BUTTON_DIAM ) ] ;
    }
    
    [ self returnStatus ] ;
}

- ( BOOL ) on
{
    return isOn ;
}

- ( void ) toggleAnimated : ( BOOL ) _animated
{
    if( isOn )
    {
        [ self setOn : NO animated : _animated ] ;
    }
    else
    {
        [ self setOn : YES animated : _animated ] ;
    }
}

- ( void ) returnStatus
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [ returnTarget performSelector : returnAction withObject : self ] ;
#pragma clang diagnostic pop
}

#pragma mark - Touch event methods.
- ( void ) touchesBegan : ( NSSet* ) _touches withEvent : ( UIEvent* ) _event
{
    UITouch* touch = [ _touches anyObject ] ;
    
    firstTouchPoint         = [ touch locationInView : self ] ;
    touchDistanceFromButton = firstTouchPoint.x - viewForBtn.frame.origin.x ;
}

- ( void ) touchesMoved : ( NSSet* ) _touches withEvent : ( UIEvent* ) _event
{
    UITouch* touch          = [ _touches anyObject ] ;
    CGPoint lastTouchPoint  = [ touch locationInView : self ] ;
    
    if( firstTouchPoint.x < lastTouchPoint.x )
    {
        [ viewForBtn setFrame : CGRectMake( lastTouchPoint.x - touchDistanceFromButton, 0, BUTTON_DIAM, BUTTON_DIAM ) ] ;
    }
    else
    {
        [ viewForBtn setFrame : CGRectMake( lastTouchPoint.x - touchDistanceFromButton, 0, BUTTON_DIAM, BUTTON_DIAM ) ] ;
    }
    
    if( viewForBtn.frame.origin.x > (WIDTH - BUTTON_DIAM - HORZ_PADDING ) )
    {
        [ viewForBtn setFrame : CGRectMake( WIDTH - BUTTON_DIAM - HORZ_PADDING, 0, BUTTON_DIAM, BUTTON_DIAM ) ] ;
    }
    else if( viewForBtn.frame.origin.x < HORZ_PADDING )
    {
        [ viewForBtn setFrame : CGRectMake( HORZ_PADDING, 0, BUTTON_DIAM,BUTTON_DIAM ) ] ;
    }
    
    [ imgForBackground_On setAlpha : ( ( viewForBtn.frame.origin.x ) / ( BACK_WIDTH - BUTTON_DIAM ) ) ] ;
    [ imgForBackground_On setFrame : CGRectMake( 0, 0, viewForBtn.frame.origin.x + BUTTON_DIAM, BUTTON_DIAM ) ] ;
}

- ( void ) touchesEnded : ( NSSet* ) _touches withEvent : ( UIEvent* ) _event
{
    UITouch* touch          = [ _touches anyObject ] ;
    CGPoint endTouchPoint   = [ touch locationInView : self ] ;
    
    if( firstTouchPoint.x > ( endTouchPoint.x - TAP_SENSITIVITY ) &&
       firstTouchPoint.x < ( endTouchPoint.x + TAP_SENSITIVITY ) &&
       firstTouchPoint.y > ( endTouchPoint.y - TAP_SENSITIVITY ) &&
       firstTouchPoint.y < ( endTouchPoint.y + TAP_SENSITIVITY ) )
    {
        [ self toggleAnimated : YES ] ;
    }
    else
    {
        CGRect newButtonFrame ;
        float distanceToEnd ;
        BOOL needsMove = NO ;
        
        // First, edge cases ;
        if( viewForBtn.frame.origin.x == HORZ_PADDING )
        {
            distanceToEnd = 0 ;
            isOn = NO ;
        }
        else if( viewForBtn.frame.origin.x == ( WIDTH - BUTTON_DIAM - HORZ_PADDING ) )
        {
            distanceToEnd = 0 ;
            isOn = YES ;
        }
        
        if( viewForBtn.frame.origin.x < ( ( WIDTH / 2 ) - ( BUTTON_DIAM / 2 ) ) )
        {
            newButtonFrame = CGRectMake( HORZ_PADDING, 0, BUTTON_DIAM, BUTTON_DIAM ) ;
            distanceToEnd = viewForBtn.frame.origin.x ;
            isOn = NO ;
            needsMove = YES ;
        }
        else if( viewForBtn.frame.origin.x < ( WIDTH - BUTTON_DIAM - HORZ_PADDING ) )
        {
            newButtonFrame = CGRectMake( WIDTH - BUTTON_DIAM - HORZ_PADDING, 0, BUTTON_DIAM, BUTTON_DIAM ) ;
            distanceToEnd = WIDTH - viewForBtn.frame.origin.x - BUTTON_DIAM ;
            isOn = YES ;
            needsMove = YES ;
        }
        
        if( needsMove )
        {
            float animTime = distanceToEnd / 140 ;
            
            [ UIView beginAnimations : nil context : nil ] ;
            [ UIView setAnimationCurve : UIViewAnimationCurveEaseInOut ] ;
            [ UIView setAnimationDelay : 0 ] ;
            [ UIView setAnimationDuration : animTime ] ;
            
            [ viewForBtn setFrame : newButtonFrame ] ;
            
            [ imgForBackground_On setAlpha : ( ( newButtonFrame.origin.x ) / ( BACK_WIDTH - BUTTON_DIAM ) ) ] ;
            [ imgForBackground_On setFrame : CGRectMake( 0, 0, newButtonFrame.origin.x + BUTTON_DIAM, BUTTON_DIAM ) ] ;
            
            [ UIView commitAnimations ] ;
        }
        
        [ self returnStatus ] ;
    }
}

- ( void ) touchesCancelled : ( NSSet* ) _touches withEvent : ( UIEvent* ) _event
{
    [ self touchesEnded : _touches withEvent : _event ] ;
}


#pragma mark - Event handling
- ( void ) addTarget : ( id ) target action : ( SEL ) action forControlEvents : ( UIControlEvents ) events
{
    if( events & UIControlEventValueChanged )
    {
        returnTarget = target ;
        returnAction = action ;
    }
}

@end