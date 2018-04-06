//
//  SocialEditProfile.h
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
@class SocialSwitchControl ;

// --- Defines --- ;
// SocialEditProfile Class ;
@interface SocialEditProfile : UIViewController < UITextFieldDelegate >
{
    IBOutlet UIImageView*       imgForBackground ;
    IBOutlet UIScrollView*      viewForScroll ;
    IBOutlet UIView*            viewForContent ;
    
    IBOutlet UITextField*       txtForName ;
    IBOutlet UITextField*       txtForUsername ;
    IBOutlet UITextField*       txtForWebsite ;
    IBOutlet UITextField*       txtForBio ;
    IBOutlet UIButton*          btnForChangePassword ;
    IBOutlet UILabel*           lblForPrivateInfo ;
    IBOutlet UITextField*       txtForEmail ;
    IBOutlet UITextField*       txtForPhone ;
    IBOutlet UITextField*       txtForGender ;
    IBOutlet SocialSwitchControl* switchForPhotoPrivate ;
    IBOutlet UILabel*           lblForPhotoPrivate ;
}

// Properties ;
@property ( nonatomic, retain ) SocialUserProfile*      userProfile ;

@end