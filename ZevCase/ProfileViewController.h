//
//  ProfileViewController.h
//  ZevCase
//
//  Created by Yu Li on 10/2/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SocialUserProfile;
@class SocialUser;

@interface ProfileViewController : UIViewController< UITableViewDelegate , UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    IBOutlet UITableView*       tblForFeed ;
}

@property ( nonatomic, retain ) SocialUserProfile*      userProfile ;

@end
