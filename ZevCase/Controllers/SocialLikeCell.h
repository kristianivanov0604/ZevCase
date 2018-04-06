//
//  SocialLikeCell.h
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import <UIKit/UIKit.h>

// --- Classes --- ;
@class SocialLike ;

// --- Defines --- ;
// SocialLikeCell Class ;
@interface SocialLikeCell : UITableViewCell
{
    IBOutlet UILabel*       lblForUsername ;
    IBOutlet UILabel*       lblForName ;
    IBOutlet UIImageView*   imgForAvatar ;
}

// Properties ;
@property ( nonatomic, retain ) SocialLike*     like ;

// Functions ;
+ ( SocialLikeCell* ) sharedCell ;

@end