//
//  SocialActionSheet.m
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import "SocialActionSheet.h"

// --- Defines --- ;
// SocialActionSheet Class ;
@implementation SocialActionSheet

// Functions ;
#pragma mark - SocialActionSheet
- ( id ) initWithTitle : ( NSString* ) _title
              delegate : ( id < UIActionSheetDelegate > ) _delegate
     cancelButtonTitle : ( NSString* ) _cancelButtonTitle
destructiveButtonTitle : ( NSString* ) _destructiveButtonTitle
     otherButtonTitles : ( NSString* ) _otherButtonTitles, ...
{
    self = [ super initWithTitle : _title
                        delegate : _delegate
               cancelButtonTitle : nil
          destructiveButtonTitle : _destructiveButtonTitle
               otherButtonTitles : nil ] ;
    
    if( self )
    {
        id object ;
        va_list argumentList ;
        
        va_start( argumentList, _otherButtonTitles ) ;
        object = _otherButtonTitles ;
        
        NSMutableArray* args = [ NSMutableArray array ] ;
        
        while( 1 )
        {
            if( !object )
            {
                break ;
            }
            
            [ args addObject : object ] ;
            object = va_arg( argumentList, id ) ;
        }
        
        va_end( argumentList ) ;
        
        for( NSString* title in args )
        {
            [ self addButtonWithTitle : title ] ;
        }
        
        if( _cancelButtonTitle )
        {
            [ self addButtonWithTitle : _cancelButtonTitle ] ;
            self.cancelButtonIndex = self.numberOfButtons - 1 ;
        }
     }
    
    return self ;
}

- ( void ) drawRect : ( CGRect ) _rect
{
    
}

- ( void ) showFromToolbar : ( UIToolbar* ) _view
{
    [ super showFromToolbar : _view ] ;
    
    // Change ;
    [ self changeActionSheet ] ;
}

- ( void ) showFromTabBar : ( UITabBar* ) _view
{
    [ super showFromTabBar : _view ] ;
    
    // Change ;
    [ self changeActionSheet ] ;
}

- ( void ) showFromBarButtonItem : ( UIBarButtonItem* ) _item animated : ( BOOL ) _animated
{
    [ super showFromBarButtonItem : _item animated : _animated ] ;
    
    // Change ;
    [ self changeActionSheet ] ;
}

- ( void ) showFromRect : ( CGRect ) _rect inView : ( UIView* ) _view animated : ( BOOL ) _animated
{
    [ super showFromRect : _rect inView : _view animated : _animated ] ;
    
    // Change ;
    [ self changeActionSheet ] ;
}

- ( void ) showInView : ( UIView* ) _view
{
    [ super showInView : _view ] ;
    
    // Change ;
    [ self changeActionSheet ] ;
}

- ( void ) changeActionSheet
{
    // Background ;
    UIImage* image = [ [ UIImage imageNamed : @"actionsheet-background.png"] stretchableImageWithLeftCapWidth : 5 topCapHeight : 100 ] ;
    UIImageView* imageView = [ [ UIImageView alloc ] initWithImage : image ]  ;
    
    [ imageView setFrame : [ self bounds ] ]  ;
    [ imageView setAutoresizingMask : UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ] ;
    
    [ self insertSubview : imageView atIndex : 0 ] ;
    
    // Title ;
    UILabel* titleLabel = [ self valueForKey : @"_titleLabel" ] ;
    
    [ titleLabel setFont : [ UIFont boldSystemFontOfSize : 16.0f ] ] ;
    
    // Buttons ;
    NSArray* buttons = [ self valueForKey : @"_buttons" ] ;
    
    UIImage* defaultNormal = [ [ UIImage imageNamed : @"actionsheet-button-default-default.png" ] stretchableImageWithLeftCapWidth : 5 topCapHeight : 24 ] ;
    UIImage* defaultActive = [ [ UIImage imageNamed : @"actionsheet-button-default-active.png" ] stretchableImageWithLeftCapWidth : 5 topCapHeight : 24 ] ;
    UIImage* cancelNormal = [ [ UIImage imageNamed : @"actionsheet-button-cancel-default.png" ] stretchableImageWithLeftCapWidth : 5 topCapHeight : 24 ] ;
    UIImage* cancelActive = [ [ UIImage imageNamed : @"actionsheet-button-cancel-active.png" ] stretchableImageWithLeftCapWidth : 5 topCapHeight : 24 ] ;
    UIImage* destructiveNormal = [ [ UIImage imageNamed : @"actionsheet-button-negative-default.png" ] stretchableImageWithLeftCapWidth : 5 topCapHeight : 24 ] ;
    UIImage* destructiveActive = [ [ UIImage imageNamed : @"actionsheet-button-negative-active.png" ] stretchableImageWithLeftCapWidth : 5 topCapHeight : 24 ] ;
    
    for( NSInteger index = 0 ; index < [ buttons count ] ; index ++ )
    {
        UIButton* button = [ buttons objectAtIndex : index ] ;
        
        // Font ;
        [ button.titleLabel setFont : [ UIFont boldSystemFontOfSize : 16.0f ] ] ;
        
        // Color ;
        [ button setTitleColor : [ UIColor whiteColor ] forState : UIControlStateNormal ] ;
        [ button setTitleColor : [ UIColor whiteColor ] forState : UIControlStateHighlighted ] ;
        
        // Background Image ;
        if( index == [ self destructiveButtonIndex ] )
        {
            [ button setBackgroundImage : destructiveNormal forState : UIControlStateNormal ] ;
            [ button setBackgroundImage : destructiveActive forState : UIControlStateHighlighted ] ;
        }
        else if( index == [ self cancelButtonIndex ] )
        {
            [ button setBackgroundImage : cancelNormal forState : UIControlStateNormal ] ;
            [ button setBackgroundImage : cancelActive forState : UIControlStateHighlighted ] ;
        }
        else
        {
            [ button setBackgroundImage : defaultNormal forState : UIControlStateNormal ] ;
            [ button setBackgroundImage : defaultActive forState : UIControlStateHighlighted ] ;
        }
    }
}

@end