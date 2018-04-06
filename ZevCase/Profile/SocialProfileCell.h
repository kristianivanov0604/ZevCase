//
//  SocialProfileCell.h
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
@class SocialPost ;
@class SocialProfileButton ;

// --- Defines --- ;
// SocialProfileUser Class ;
@interface SocialProfileUser : UITableViewCell
{
    IBOutlet UIImageView*   imgForAvatar ;
    IBOutlet UILabel *lblUsername;
    IBOutlet UILabel *lblBio;
    IBOutlet UILabel*       lblForPhotos ;
    IBOutlet UILabel*       lblForFollowers ;
    IBOutlet UILabel*       lblForFollowings ;

    IBOutlet UIButton*      btnForPhotos ;
    IBOutlet UIButton*      btnForFollowers ;
    IBOutlet UIButton*      btnForFollowings ;
    IBOutlet UIButton*      btnForEditProfile ;
    
    IBOutlet UILabel*       lblForEditProfile;
    IBOutlet UIImageView*   imgForEditProfile;
    
    IBOutlet UIView *viewCases;
    IBOutlet UIView *viewFollowers;
    IBOutlet UIView *viewFollowings;
    
    IBOutlet UIButton *btnBack;
    
}

// Properties ;
@property ( nonatomic, retain ) id                  delegate ;
@property ( nonatomic, retain ) SocialUserProfile*  userProfile ;

// Functions ;
+ ( SocialProfileUser* ) sharedCell ;
- (IBAction)backAction:(id)sender;
- (void)setHideBackButton:(BOOL)flag;

@end

// SocialProfileMode Class ;
@interface SocialProfileMode : UITableViewCell
{
    IBOutlet UIButton*  btnForGrid ;
    IBOutlet UIButton*  btnForList ;
}

// Properties ;
@property ( nonatomic, retain ) id                  delegate ;

// Functions ;
+ ( SocialProfileMode* ) sharedCell ;
- ( void ) setViewMode : ( NSInteger ) _viewMode ;

@end

// SocialProfileButton Class ;
@interface SocialProfileButton : UIView
{
    IBOutlet UIImageView*   imgForBackground ;
}

// Properties ;
@property ( nonatomic, retain ) id                  delegate ;

// Functions ;
+ ( SocialProfileButton* ) sharedView ;

@end