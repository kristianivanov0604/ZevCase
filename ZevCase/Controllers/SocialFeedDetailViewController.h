//
//  SocialFeedDetailViewController.h
//  ZevCase
//
//  Created by threek on 1/25/14.
//  Copyright (c) 2014 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SocialFeed ;

@interface SocialFeedDetailViewController : UIViewController
{
    IBOutlet UIScrollView *scrviewMain;
    
    IBOutlet UIView         *viewMain;
    IBOutlet UIView         *viewFeed;
    IBOutlet UIImageView    *imgFeed;
    IBOutlet UIImageView *backImageView;
    IBOutlet UILabel        *lblFeedTitle;
    
    IBOutlet UIImageView    *imgLike;
    IBOutlet UIButton       *btnLike;
    IBOutlet UILabel        *lblLikes;
    IBOutlet UIImageView    *imgComment;
    IBOutlet UIButton       *btnComment;
    
    IBOutlet UIView         *viewCart;
    IBOutlet UIButton       *btnCart;
    
    IBOutlet UIView         *viewSelectDevice;
    IBOutlet UILabel        *lblSelectedDevice;
    IBOutlet UIButton       *btnSelectDevice;
    
    IBOutlet UIView         *viewUserInfo;
    IBOutlet UIImageView    *imgUserAvator;
    IBOutlet UILabel        *lblUsername;
    IBOutlet UITextView     *txtUserBio;
    
    IBOutlet UIView         *viewMore;
    IBOutlet UIButton       *btnUserMoreview;
    
    IBOutlet UIView         *viewFollow;
    IBOutlet UIButton       *btnFollowDesigner;
}

// Properties ;
@property ( nonatomic, retain ) SocialFeed*     feed ;

// Functions ;
- ( id ) initWithFeed : ( SocialFeed* ) _feed ;

- (IBAction)addCartAction:(id)sender;
- (IBAction)selectDeviceAction:(id)sender;
- (IBAction)viewMoreUserAction:(id)sender;
- (IBAction)didLikeAction:(id)sender;
- (IBAction)didCommentAction:(id)sender;


- (void) setDeviceType:(NSString *)deviceName;

@end
