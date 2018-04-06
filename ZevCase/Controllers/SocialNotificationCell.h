//
//  SocialNotificationCell.h
//  ZevCase
//
//  Created by Yu Li on 1/7/14.
//  Copyright (c) 2014 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SocialNotification;

@interface SocialNotificationCell : UITableViewCell{
    IBOutlet UIImageView    *imgForAvatar;
    IBOutlet UILabel        *lblForUsername;
    IBOutlet UILabel        *lblForTime;
    IBOutlet UILabel        *lblForMessage;
}

@property ( nonatomic, retain ) SocialNotification*     notifications ;

@property ( nonatomic, retain ) id              delegate ;

+ ( SocialNotificationCell* ) sharedCell ;


@end
