//
//  SocialCommentCell.h
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import <UIKit/UIKit.h>

// --- Classes --- ;
@class SocialComment ;

// --- Defines --- ;
// SocialCommentCell Class ;
@interface SocialCommentCell : UITableViewCell
{
    IBOutlet UIView*        viewForComment ;
    
    IBOutlet UIImageView*   imgForAvatar ;
    IBOutlet UILabel*       lblForUser ;
    IBOutlet UILabel*       lblForComment ;
    IBOutlet UIActivityIndicatorView* indicatorForComment ;
}

// Properties ;
@property ( nonatomic, retain ) id              delegate ;
@property ( nonatomic, retain ) SocialComment*  comment ;

// Functions ;
+ ( SocialCommentCell* ) sharedCell ;

@end