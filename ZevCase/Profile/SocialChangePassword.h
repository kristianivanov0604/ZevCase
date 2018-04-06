//
//  SocialChangePassword.h
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import <UIKit/UIKit.h>

// --- Classes --- ;
@class SocialUser ;
@class SocialSwitchControl ;

// --- Defines --- ;
// SocialChangePassword Class ;
@interface SocialChangePassword : UIViewController < UITextFieldDelegate >
{
    IBOutlet UIImageView*       imgForBackground ;
    IBOutlet UIScrollView*      viewForScroll ;
    IBOutlet UIView*            viewForContent ;
    
    IBOutlet UITextField*       txtForOldPassword ;
    IBOutlet UITextField*       txtForPassword ;
    IBOutlet UITextField*       txtForPasswordConfirm ;
}

@end