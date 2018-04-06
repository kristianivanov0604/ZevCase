//
//  SocialUserController.h
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
// SocialUserController Class ;
@interface SocialUserController : UIViewController < UITableViewDelegate, UIAlertViewDelegate >
{
    IBOutlet UIImageView*       imgForBackground ;
    IBOutlet UITableView*       tblForFeed ;
}

// Properties ;
@property ( nonatomic, retain ) NSString*           username ;
@property ( nonatomic, retain ) SocialUserProfile*  userProfile ;

// Functions ;
- ( id ) initWithUser : ( SocialUser* ) _user ;
- ( id ) initWithUsername : ( NSString* ) _username ;

- (void) didBackButtonAction:(id)sender;

@end