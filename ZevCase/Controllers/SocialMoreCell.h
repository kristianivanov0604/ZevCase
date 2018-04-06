//
//  SocialMoreCell.h
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import <UIKit/UIKit.h>

// --- Defines --- ;
// SocialMoreCell Class ;
@interface SocialMoreCell : UITableViewCell
{
    IBOutlet UIImageView*   imgForAnimation ;
}

// Properties ;
@property ( nonatomic, retain ) id      delegate ;

// Functions ;
+ ( SocialMoreCell* ) sharedCell ;
- ( void ) startAnimation ;
- ( void ) stopAnimation ;

@end