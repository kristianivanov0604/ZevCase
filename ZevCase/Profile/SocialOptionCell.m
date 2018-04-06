//
//  SocialOptionCell.m
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import "SocialOptionCell.h"

// --- Defines --- ;
// SocialOptionHeader Class ;
@implementation SocialOptionHeader

// Functions ;
+ ( SocialOptionHeader* ) sharedView
{
    NSArray*            array   = [ [ NSBundle mainBundle ] loadNibNamed : @"SocialOptionCell" owner : nil options : nil ] ;
    SocialOptionHeader* view    = [ array objectAtIndex : 0 ] ;
    
    return view ;
}

+ ( CGFloat ) height : ( NSString* ) _title
{
    return 32.0f ;
}

#pragma mark - SocialOptionHeader
- ( void ) awakeFromNib
{
    [ lblForTitle setFont : [ UIFont fontWithName : @"FreightSans BoldSC" size : 16.0f ] ] ;
}

- ( void ) dealloc
{
  
}

- ( void ) setTitle : ( NSString* ) _title
{
    [ lblForTitle setText : _title ] ;
}

@end

// SocialOptionFooter Class ;
@implementation SocialOptionFooter

// Functions ;
+ ( SocialOptionFooter* ) sharedView
{
    NSArray*            array   = [ [ NSBundle mainBundle ] loadNibNamed : @"SocialOptionCell" owner : nil options : nil ] ;
    SocialOptionFooter* view    = [ array objectAtIndex : 1 ] ;
    
    return view ;
}

+ ( CGFloat ) height : ( NSString* ) _title
{
    // Frame ;
    CGSize  size    = [ _title sizeWithFont : [ UIFont systemFontOfSize : 14.0f ]
                          constrainedToSize : CGSizeMake( 280.0f, 999.0f )
                              lineBreakMode : NSLineBreakByWordWrapping ] ;
    CGFloat height  = size.height + 12.0f ;
    
    return height ;
}

#pragma mark - SocialOptionFooter
- ( void ) dealloc
{
    
}

- ( void ) setTitle : ( NSString* ) _title
{
    [ lblForTitle setText : _title ] ;
}

@end

// SocialOptionCell Class ;
@implementation SocialOptionCell

// Properties ;
@synthesize delegate ;

// Funtions ;
#pragma mark - SocialOptionCell
- ( void ) layoutSubviews
{
    switch( type )
    {
        case 0 :    // Single ;
            [ self.backgroundView setFrame : CGRectMake( 0, -5, 320, 54 ) ] ;
            [ self.selectedBackgroundView setFrame : CGRectMake( 0, -5, 320, 54 ) ] ;
            break ;
            
        case 1 : // Top ;
            [ self.backgroundView setFrame : CGRectMake( 0, -4, 320, 49 ) ] ;
            [ self.selectedBackgroundView setFrame : CGRectMake( 0, -4, 320, 49 ) ] ;
            break ;
            
        case 2 : // Bottom ;
            [ self.backgroundView setFrame : CGRectMake( 0, 0, 320, 49 ) ] ;
            [ self.selectedBackgroundView setFrame : CGRectMake( 0, 0, 320, 49 ) ] ;
            break ;
            
        case 3 :
            [ self.backgroundView setFrame : CGRectMake( 0, 0, 320, 44 ) ] ;
            [ self.selectedBackgroundView setFrame : CGRectMake( 0, 0, 320, 44 ) ] ;
            break ;
            
        default :
            break ;
    }
}

- ( void ) setImage : ( UIImage* ) _normal highlight : ( UIImage* ) _highlight
{
    [ ( UIImageView* )self.backgroundView setImage : _normal ] ;
    [ ( UIImageView* )self.selectedBackgroundView setHighlightedImage : _highlight ] ;
}

- ( void ) setType : ( NSInteger ) _type
{
    type    = _type ;
    [ self setNeedsLayout ] ;
}

- ( void ) setTitle : ( NSString* ) _title
{
    [ lblForTitle setText : _title ] ;
}

@end

// SocialOptionIndicator Class ;
@implementation SocialOptionIndicator

// Properties ;

// Functions ;
#pragma mark - Shared Funtions
+ ( SocialOptionIndicator* ) sharedCell
{
    NSArray*                array   = [ [ NSBundle mainBundle ] loadNibNamed : @"SocialOptionCell" owner : nil options : nil ] ;
    SocialOptionIndicator*  cell    = [ array objectAtIndex : 2 ] ;
    
    return cell ;
}

#pragma mark - SocialOptionIndicator
- ( id ) initWithFrame : ( CGRect ) _frame
{
    self = [ super initWithFrame : _frame ] ;
    
    if( self )
    {
        
    }
    
    return self ;
}

- ( void ) dealloc
{

}

- ( void ) awakeFromNib
{
    
}

@end

// SocialOptionButton Class ;
@implementation SocialOptionButton

// Properties ;

// Functions ;
#pragma mark - Shared Funtions
+ ( SocialOptionButton* ) sharedCell
{
    NSArray*                array   = [ [ NSBundle mainBundle ] loadNibNamed : @"SocialOptionCell" owner : nil options : nil ] ;
    SocialOptionButton*     cell    = [ array objectAtIndex : 3 ] ;
    
    return cell ;
}

#pragma mark - SocialOptionButton
- ( id ) initWithFrame : ( CGRect ) _frame
{
    self = [ super initWithFrame : _frame ] ;
    
    if( self )
    {
        
    }
    
    return self ;
}

- ( void ) dealloc
{

}

- ( void ) awakeFromNib
{
    
}

@end

// SocialOptionSwitch Class ;
@implementation SocialOptionSwitch

// Properties ;

// Functions ;
#pragma mark - Shared Funtions
+ ( SocialOptionSwitch* ) sharedCell
{
    NSArray*                array   = [ [ NSBundle mainBundle ] loadNibNamed : @"SocialOptionCell" owner : nil options : nil ] ;
    SocialOptionSwitch*     cell    = [ array objectAtIndex : 4 ] ;
    
    return cell ;
}

#pragma mark - SocialOptionSwitch
- ( id ) initWithFrame : ( CGRect ) _frame
{
    self = [ super initWithFrame : _frame ] ;
    
    if( self )
    {
        
    }
    
    return self ;
}

- ( void ) dealloc
{

}

- ( void ) awakeFromNib
{
    
}

@end

// SocialOptionCheckmark Class ;
@implementation SocialOptionCheckmark

// Properties ;

// Functions ;
#pragma mark - Shared Funtions
+ ( SocialOptionCheckmark* ) sharedCell
{
    NSArray*                array   = [ [ NSBundle mainBundle ] loadNibNamed : @"SocialOptionCell" owner : nil options : nil ] ;
    SocialOptionCheckmark*  cell    = [ array objectAtIndex : 5 ] ;
    
    return cell ;
}

#pragma mark - SocialOptionCheckmark
- ( id ) initWithFrame : ( CGRect ) _frame
{
    self = [ super initWithFrame : _frame ] ;
    
    if( self )
    {
        
    }
    
    return self ;
}

- ( void ) dealloc
{
     
}

- ( void ) awakeFromNib
{
    
}

@end