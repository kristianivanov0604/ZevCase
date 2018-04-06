//
//  SocialLikeController.h
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
// SocialLikeController Class ;
@interface SocialLikeController : UIViewController < UITableViewDelegate >
{
    IBOutlet UITableView*       tblForLike ;
}

// Properties ;
@property ( nonatomic, retain ) SocialFeed*     feed ;

// Functions ;
- ( id ) initWithFeed : ( SocialFeed* ) _feed ;

@end