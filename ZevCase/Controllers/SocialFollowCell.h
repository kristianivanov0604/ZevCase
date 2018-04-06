//
//  SocialFollowCell.h
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import <UIKit/UIKit.h>

// --- Classes --- ;
@class SocialFollow ;

// --- Defines --- ;
// SocialFollowCell Class ;
@interface SocialFollowCell : UITableViewCell
{
    IBOutlet UILabel*       lblForUsername ;
    IBOutlet UILabel*       lblForName ;
    IBOutlet UIImageView*   imgForAvatar ;
    IBOutlet UIButton*      btnForFollow ;
}

// Properties ;
@property ( nonatomic, retain ) id              delegate ;
@property ( nonatomic, retain ) SocialFollow*   follow ;

// Functions ;
+ ( SocialFollowCell* ) sharedCell ;

@end