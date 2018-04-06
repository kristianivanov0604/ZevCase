//
//  SocialFeedCell.h
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

// --- Classes --- ;
@class SocialUser ;
@class SocialFeed ;
@class SocialComment ;

// --- Defines --- ;
// SocialFeedUser Class ;
@interface SocialFeedUser : UITableViewCell
{
    IBOutlet UIImageView*       imgForAvatar ;
    IBOutlet UILabel*           lblForUsername ;
    IBOutlet UILabel*           lblForTime ;
    IBOutlet UILabel*           lblForName ;
}

// Properties ;
@property ( nonatomic, retain ) id              delegate ;
@property ( nonatomic, retain ) SocialFeed*     feed ;

// Functions ;
+ ( SocialFeedUser* ) sharedCell ;

@end

// SocialFeedPhoto Class ;
@interface SocialFeedPhoto : UITableViewCell
{
    IBOutlet UIImageView*       imgForPhoto ;
}

// Properties ;
@property ( nonatomic, retain ) id              delegate ;
@property ( nonatomic, retain ) SocialFeed*     feed ;

// Functions ;
+ ( SocialFeedPhoto* ) sharedCell ;

@end

// SocialFeedLikes Class ;
@interface SocialFeedLikes : UITableViewCell
{
    IBOutlet UIButton*          btnForLikes ;
}

// Properties ;
@property ( nonatomic, retain ) id              delegate ;
@property ( nonatomic, retain ) SocialFeed*     feed ;

// Functions ;
+ ( SocialFeedLikes* ) sharedCell ;

@end

// SocialFeedComment Class ;
@interface SocialFeedComment : UITableViewCell < TTTAttributedLabelDelegate >
{
    IBOutlet TTTAttributedLabel* lblForComment ;

    IBOutlet UIButton *btnCommentUserAvator;
    IBOutlet UILabel *lblCommentUsername;
    IBOutlet UILabel *lblComment;
    
}

// Properties ;
@property ( nonatomic, retain ) id              delegate ;
@property ( nonatomic, retain ) SocialComment*  comment ;

// Functions ;
+ ( SocialFeedComment* ) sharedCell ;
+ ( CGFloat ) height : ( SocialComment* ) _comment ;
- (IBAction)commentUserSelectAction:(id)sender;

@end

// SocialFeedDetail Class ;
@interface SocialFeedDetail : UITableViewCell < UIActionSheetDelegate >
{
    IBOutlet UIButton*          btnForLike ;
    IBOutlet UIButton*          btnForComment ;
    IBOutlet UIButton*          btnForMore ;
    IBOutlet UILabel*           lblPrice ;
    
    IBOutlet UIButton *btnLike;
    IBOutlet UIImageView *imgLike;
    IBOutlet UIButton *btnComment;
    IBOutlet UIImageView *imgComment;
    IBOutlet UIButton *btnShopping;
    
}

// Properties ;
@property ( nonatomic, retain ) id              delegate ;
@property ( nonatomic, retain ) SocialFeed*     feed ;

// Functions ;
+ ( SocialFeedDetail* ) sharedCell ;

@end

// SocialFeedGrid Class ;

#define kNumberOfOneCell    2

@interface SocialFeedGrid : UITableViewCell
{
    IBOutlet UIView *viewFeed1;
    IBOutlet UIButton*          btnForFeed1 ;
    IBOutlet UIImageView*       imgForFeed1 ;
    IBOutlet UILabel *          lblTitle1 ;
    IBOutlet UILabel *          lblUsername1 ;
    IBOutlet UILabel *          lblPrice1 ;
    
    IBOutlet UIView *viewFeed2;
    IBOutlet UIButton*          btnForFeed2 ;
    IBOutlet UIImageView*       imgForFeed2 ;
    IBOutlet UILabel *          lblTitle2 ;
    IBOutlet UILabel *          lblUsername2 ;
    IBOutlet UILabel *          lblPrice2 ;
    
    IBOutlet UIButton*          btnForFeed3 ;
    IBOutlet UIImageView*       imgForFeed3 ;
}

// Properties ;
@property ( nonatomic, retain ) id              delegate ;
@property ( nonatomic, retain ) SocialFeed*     feed1 ;
@property ( nonatomic, retain ) SocialFeed*     feed2 ;
@property ( nonatomic, retain ) SocialFeed*     feed3 ;

// Functions ;
+ ( SocialFeedGrid* ) sharedCell ;

@end