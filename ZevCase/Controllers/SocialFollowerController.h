//
//  SocialFollowerController.h
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import <UIKit/UIKit.h>

// --- Classes --- ;
@class SocialUser ;

// --- Defines --- ;
// SocialFollowerController Class ;
@interface SocialFollowerController : UIViewController < UITableViewDelegate >
{
    IBOutlet UIImageView*       imgForBackground ;
    IBOutlet UITableView*       tblForFollower ;
}

// Properties ;
@property ( nonatomic, retain ) SocialUser*     user ;

// Functions ;
- ( id ) initWithUser : ( SocialUser* ) _user ;

@end