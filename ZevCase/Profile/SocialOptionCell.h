//
//  SocialOptionCell.h
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import <UIKit/UIKit.h>

// --- Classes --- ;
@class SocialSwitchControl ;

// --- Defines --- ;
// SocialOptionHeader Class ;
@interface SocialOptionHeader : UIView
{
    IBOutlet UILabel*       lblForTitle ;
}

// Funtions ;
+ ( SocialOptionHeader* ) sharedView ;
+ ( CGFloat ) height : ( NSString* ) _title ;

- ( void ) setTitle : ( NSString* ) _title ;

@end

// PlaceView Class ;
@interface SocialOptionFooter : UIView
{
    IBOutlet UILabel*       lblForTitle ;
}

// Funtions ;
+ ( SocialOptionFooter* ) sharedView ;
+ ( CGFloat ) height : ( NSString* ) _title ;

- ( void ) setTitle : ( NSString* ) _title ;

@end

// SocialOptionCell Class ;
@interface SocialOptionCell : UITableViewCell
{
    IBOutlet UILabel*       lblForTitle ;
    NSInteger               type ;
}

// Properties ;
@property ( nonatomic, retain ) id          delegate ;

// Functions ;
- ( void ) setImage : ( UIImage* ) _normal highlight : ( UIImage* ) _highlight ;
- ( void ) setType : ( NSInteger ) _type ;
- ( void ) setTitle : ( NSString* ) _title ;

@end

// SocialOptionIndicator Class ;
@interface SocialOptionIndicator : SocialOptionCell
{
    
}

// Properties ;

// Functions ;
+ ( SocialOptionIndicator* ) sharedCell ;

@end

// SocialOptionButton Class ;
@interface SocialOptionButton : SocialOptionCell
{
    
}

// Properties ;

// Functions ;
+ ( SocialOptionButton* ) sharedCell ;

@end

// SocialOptionSwitch Class ;
@interface SocialOptionSwitch : SocialOptionCell
{
    IBOutlet SocialSwitchControl*   state ;
}

// Properties ;

// Functions ;
+ ( SocialOptionSwitch* ) sharedCell ;

@end

// SocialOptionCheckmark Class ;
@interface SocialOptionCheckmark : SocialOptionCell
{
    
}

// Properties ;

// Functions ;
+ ( SocialOptionCheckmark* ) sharedCell ;

@end