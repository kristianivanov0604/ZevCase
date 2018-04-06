//
//  SocialOptionController.h
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
// SocialOptionController Class ;
@interface SocialOptionController : UIViewController < UITableViewDelegate >
{
    IBOutlet UIImageView*       imgForBackground ;
    IBOutlet UITableView*       tblForOption ;
}

@end