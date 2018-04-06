//
//  SocialCommentController.h
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import <UIKit/UIKit.h>

// --- Classes --- ;
@class SocialFeed ;

// --- Defines --- ;
// SocialCommentController Class ;
@interface SocialCommentController : UIViewController < UITableViewDelegate, UITextFieldDelegate >
{
    IBOutlet UITableView*       tblForComment ;

    IBOutlet UINavigationBar*   naviForComment ;
    IBOutlet UIBarButtonItem*   btnForComment ;
    IBOutlet UITextField*       txtForComment ;
}

// Properties ;
@property ( nonatomic, retain ) SocialFeed*     feed ;

// Functions ;
- ( id ) initWithFeed : ( SocialFeed* ) _feed ;

@end