//
//  SocialProfileController.h
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import <UIKit/UIKit.h>

// --- Classes --- ;
@class SocialUser ;
@class SocialUserProfile ;

// --- Defines --- ;
// SocialProfileController Class ;
@interface SocialProfileController : UIViewController
{
    IBOutlet UIImageView*       imgForBackground ;
    IBOutlet UITableView*       tblForFeed ;
}

// Properties ;
@property ( nonatomic, retain ) SocialUserProfile*      userProfile ;

@end