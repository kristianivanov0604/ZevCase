//
//  SocialNotificationCell.m
//  ZevCase
//
//  Created by Yu Li on 1/7/14.
//  Copyright (c) 2014 Yu Li. All rights reserved.
//

#import "SocialNotificationCell.h"
#import "SocialNotification.h"
#import "SocialHelper.h"

#import "UIImageView+AFNetworking.h"

@implementation SocialNotificationCell
@synthesize notifications;
@synthesize delegate;

#pragma mark - Shared Funtions
+ ( SocialNotificationCell* ) sharedCell
{
    NSArray*                    array   = [ [ NSBundle mainBundle ] loadNibNamed : @"SocialNotificationCell" owner : nil options : nil ] ;
    SocialNotificationCell*     cell    = [ array objectAtIndex : 0 ] ;
    
    return cell ;
}

#pragma mark - Social Notification Cell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- ( void ) awakeFromNib
{
    [ [ imgForAvatar layer ] setMasksToBounds : YES ] ;
    [ [ imgForAvatar layer ] setBorderColor : [ UIColor grayColor ].CGColor ] ;
    [ [ imgForAvatar layer ] setBorderWidth : 0.5f ] ;
    [ [ imgForAvatar layer ] setCornerRadius : 3.0f ] ;
}

- ( void ) setNotifications : (SocialNotification *)_notification
{
    // Set ;
    
    notifications = _notification ;
    
    // UI ;
    [ imgForAvatar setImageWithURL : [ NSURL URLWithString : [ notifications avatar ] ] placeholderImage : [ UIImage imageNamed : @"anonymousUser.png" ] ] ;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    [imgForAvatar setUserInteractionEnabled:YES];
    tapGesture.numberOfTapsRequired = 1;
    [imgForAvatar addGestureRecognizer:tapGesture];
    
    if ([notifications following]) {
        [ lblForUsername setText : [NSString stringWithFormat:@"%@ started followed you", [notifications username]] ] ;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: lblForUsername.attributedText];
        [text addAttribute: NSForegroundColorAttributeName value: [UIColor blueColor] range: NSMakeRange(0, text.length - 22)];
        [lblForUsername setAttributedText: text];
        
    }else{
        [ lblForUsername setText : [NSString stringWithFormat:@"%@ started liked you", [notifications username]] ] ;
    }
    
    UITapGestureRecognizer *tapGestureUsername = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    [lblForUsername setUserInteractionEnabled:YES];
    tapGestureUsername.numberOfTapsRequired = 1;
    [lblForUsername addGestureRecognizer:tapGestureUsername];
    
    [ lblForTime setText : [NSString stringWithFormat:@"%@ ago", [ SocialHelper timeElapsedNotification : [ notifications date ] ] ] ] ;
}

#pragma mark - avatar tap gesture

- (void) actionTap : (id)_sender{
    
    if( [ delegate respondsToSelector : @selector( didSelectedUser: ) ] )
    {
        [ delegate performSelector : @selector( didSelectedUser: ) withObject : [ self notifications ] ] ;
    }
}

@end
