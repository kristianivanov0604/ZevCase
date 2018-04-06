//
//  SocialProfileCell.m
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import "SocialProfileCell.h"

#import "SocialUser.h"
#import "SocialUserProfile.h"
#import "SocialCommunication.h"

#import "GlobalData.h"
#import "UIImageView+AFNetworking.h"
// --- Defines --- ;
// SocialProfileUser Class ;
@implementation SocialProfileUser

// Properties ;
@synthesize delegate ;
@synthesize userProfile ;

// Functions ;
+ ( SocialProfileUser* ) sharedCell
{
    NSArray*            array   = [ [ NSBundle mainBundle ] loadNibNamed : @"SocialProfileCell" owner : nil options : nil ] ;
    SocialProfileUser*  cell    = [ array objectAtIndex : 3 ] ;
    
    return cell ;
}

- (IBAction)backAction:(id)sender {
    SEL backAction = @selector(didBackButtonAction:);
    if (self.delegate) {
        if ([self.delegate respondsToSelector:backAction]) {
            [self.delegate performSelector:backAction withObject:sender];
        }
    }
}

- (void)setHideBackButton:(BOOL)flag
{
    [btnBack setHidden:flag];
}

- ( id ) initWithStyle : ( UITableViewCellStyle ) _style reuseIdentifier : ( NSString* ) _reuseIdentifier
{
    self = [ super initWithStyle : _style reuseIdentifier : _reuseIdentifier ] ;
    
    if( self )
    {
        
    }
    
    return self ;
}

- ( void ) awakeFromNib
{
    UIImage* follower   = [ [ UIImage imageNamed : @"cell-button-active-background.png" ] resizableImageWithCapInsets : UIEdgeInsetsMake( 2.0f, 0.5f, 1.0f, 0.5f ) ] ;
    UIImage* following  = [ [ UIImage imageNamed : @"cell-button-rounded-right-active-background.png" ] resizableImageWithCapInsets : UIEdgeInsetsMake( 6.0f, 68.0f, 1.0f, 5.0f ) ] ;
    UIImage* profile    = [ [ UIImage imageNamed : @"cell-multi-mid-active.png" ] resizableImageWithCapInsets : UIEdgeInsetsMake( 12, 13, 12, 10 ) ] ;
    
    [ btnForPhotos setBackgroundImage : follower forState : UIControlStateHighlighted ] ;
    [ btnForFollowers setBackgroundImage : follower forState : UIControlStateHighlighted ] ;
    [ btnForFollowings setBackgroundImage : following forState : UIControlStateHighlighted ] ;
    [ btnForEditProfile setBackgroundImage : profile forState : UIControlStateHighlighted ] ;
    [ btnForEditProfile setEnabled : NO ] ;
    
    [imgForAvatar setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    tapGesture.numberOfTapsRequired = 1;
    [imgForAvatar addGestureRecognizer:tapGesture];
}

- ( void ) layoutSubviews
{
    [ super layoutSubviews ] ;
}

- ( void ) setSelected : ( BOOL ) _selected animated : ( BOOL ) _animated
{
    
}

#pragma mark - Set
- ( void ) setUserProfile : ( SocialUserProfile* ) _userProfile
{
    // Set ;
    userProfile    = _userProfile ;

    // UI ;
    [ lblForPhotos setText : [ NSString stringWithFormat : @"%d", [ userProfile photos ] ] ] ;
    [ lblForFollowers setText : [ NSString stringWithFormat : @"%d", [ userProfile followers ] ] ] ;
    [ lblForFollowings setText : [ NSString stringWithFormat : @"%d", [ userProfile followings ] ] ] ;
    [ lblBio setText : (userProfile.bio.length == 0 ? @"(no Bio)" : userProfile.bio)] ;
    [ lblUsername setText : [ userProfile name ] ] ;


    if (imgForAvatar != nil) {
        [imgForAvatar setImage:nil];
    }
    [ imgForAvatar setImageWithURL:[NSURL URLWithString:[userProfile avatar]] placeholderImage:[UIImage imageNamed:@"anonymousUser"]];

    [GlobalMethods setRoundView:imgForAvatar borderColor:nil];
    
    [ btnForEditProfile setEnabled : userProfile ? YES : NO ] ;
    
    [GlobalMethods setRoundView:btnForEditProfile cornorRadious:5.0f borderColor:[UIColor whiteColor] border:0.5f];

    [GlobalMethods setRoundView:viewCases cornorRadious:8.0f borderColor:[UIColor whiteColor] border:0.5f];

    [GlobalMethods setRoundView:viewFollowers cornorRadious:8.0f borderColor:[UIColor whiteColor] border:0.5f];

    [GlobalMethods setRoundView:viewFollowings cornorRadious:8.0f borderColor:[UIColor whiteColor] border:0.5f];

    
    NSLog(@"%@", [[[SocialCommunication sharedManager] me] userid]);
    if (![userProfile.userid isEqualToString:[[[SocialCommunication sharedManager] me] userid]]) {
        [imgForEditProfile setHidden:YES];
//        [btnForEditProfile setBackgroundColor:[UIColor clearColor]];
        if (userProfile.following) {
            [btnForEditProfile setTitle:@"Unfollow" forState:UIControlStateNormal];
        }else{
            [btnForEditProfile setTitle:@"Follow" forState:UIControlStateNormal];
        }
        [lblForEditProfile setHidden:YES];
    }else{
//        [imgForEditProfile setHidden:NO];
//        [lblForEditProfile setText:@"Edit Profile"];
        [btnForEditProfile setTitle:@"Edit Profile" forState:UIControlStateNormal];
//        [lblForEditProfile setHidden:NO];
//        [btnForEditProfile setBackgroundColor:[UIColor clearColor]];
    }
    
}


#pragma mark - Events

- (void)actionTap : (id)sender{
    if( [ delegate respondsToSelector : @selector( didAvatar ) ] )
    {
        [ delegate performSelector : @selector( didAvatar ) ] ;
    }
}

- ( IBAction ) onBtnPhotos : ( id ) _sender
{
    if( [ delegate respondsToSelector : @selector( didPhotos ) ] )
    {
        [ delegate performSelector : @selector( didPhotos ) ] ;
    }
}

- ( IBAction ) onBtnFollowers : ( id ) _sender
{
    if( [ delegate respondsToSelector : @selector( didFollowers ) ] )
    {
        [ delegate performSelector : @selector( didFollowers ) ] ;
    }
}

- ( IBAction ) onBtnFollowings : ( id ) _sender
{
    if( [ delegate respondsToSelector : @selector( didFollowings ) ] )
    {
        [ delegate performSelector : @selector( didFollowings ) ] ;
    }
}

- ( IBAction ) onBtnEditProfile : ( id ) _sender
{
    if ([[[[SocialCommunication sharedManager] me] userid] isEqualToString:[userProfile userid]]) {
        if( [ delegate respondsToSelector : @selector( didEditProfile ) ] )
        {
            [ delegate performSelector : @selector( didEditProfile ) ] ;
        }
    }else{
        
        [self.userProfile setFollowing:![userProfile following]];
        
        [self setFollowingProcessing:YES];
        
        void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
            
            [self setFollowingProcessing:NO];
            if (userProfile.following) {
                userProfile.followings++;
            } else {
                userProfile.followings--;
            }
            [lblForFollowings setText:[NSString stringWithFormat:@"%d", (userProfile.followings)]];
            

//            if( [ delegate respondsToSelector : @selector( didFollowProfile ) ] )
//            {
//                [ delegate performSelector : @selector( didFollowProfile ) ] ;
//            }

        } ;
        
        void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
            [self setFollowingProcessing:NO];
        } ;
        
        if ([userProfile following]) {
            [[SocialCommunication sharedManager] FollowingAdd:userProfile
                                                    successed:successed
                                                      failure:failure];
        }else{
            [[SocialCommunication sharedManager] FollowingRemove:userProfile
                                                       successed:successed
                                                         failure:failure];
        }
        
    }
    
}

- (void) setFollowingProcessing:(BOOL)flag
{
    if (flag) {
        [btnForEditProfile setEnabled:NO];
//        [btnForEditProfile setBackgroundColor:[UIColor colorWithWhite:0.2f alpha:0.8f]];
        if (userProfile.following) {
            [btnForEditProfile setTitle:@"Following" forState:(UIControlStateNormal)];
        } else {
            [btnForEditProfile setTitle:@"Unfollowing" forState:(UIControlStateNormal)];
        }
    } else {
        [btnForEditProfile setEnabled:YES];
//        [btnForEditProfile setBackgroundColor:[UIColor colorWithWhite:0.9f alpha:0.1f]];
        if (userProfile.following) {
            [btnForEditProfile setTitle:@"Unfollow" forState:(UIControlStateNormal)];
        } else {
            [btnForEditProfile setTitle:@"Follow" forState:(UIControlStateNormal)];
        }
    }
}

@end


// #########################################################################
// #########################################################################
// #########################################################################


// SocialProfileMode Class ;
@implementation SocialProfileMode

// Properties ;
@synthesize delegate ;

// Functions ;
+ ( SocialProfileMode* ) sharedCell
{
    NSArray*            array   = [ [ NSBundle mainBundle ] loadNibNamed : @"SocialProfileCell" owner : nil options : nil ] ;
    SocialProfileMode*  cell    = [ array objectAtIndex : 1 ] ;
    
    return cell ;
}

- ( id ) initWithStyle : ( UITableViewCellStyle ) _style reuseIdentifier : ( NSString* ) _reuseIdentifier
{
    self = [ super initWithStyle : _style reuseIdentifier : _reuseIdentifier ] ;
    
    if( self )
    {
        
    }
    
    return self ;
}

- ( void ) layoutSubviews
{
    [ super layoutSubviews ] ;
}

- ( void ) setSelected : ( BOOL ) _selected animated : ( BOOL ) _animated
{
    
}

- ( void ) setViewMode : ( NSInteger ) _viewMode
{
    switch( _viewMode )
    {
        case 1 :
        {
            [ btnForGrid setSelected : YES ] ;
            [ btnForList setSelected : NO ] ;
            break ;
        }
            
        case 2 :
        {
            [ btnForGrid setSelected : NO ] ;
            [ btnForList setSelected : YES ] ;
            break ;
        }
            
        default :
            break ;
    }
}

- ( IBAction ) onBtnGrid : ( id ) _sender
{
    [ self setViewMode : 1 ] ;
    
    if( [ delegate respondsToSelector : @selector( didSelectedViewMode: ) ] )
    {
        [ delegate performSelector : @selector( didSelectedViewMode: ) withObject : [NSNumber numberWithInt:1] ] ;
    }
}

- ( IBAction ) onBtnList : ( id ) _sender
{
    [ self setViewMode : 2 ] ;
    
    if( [ delegate respondsToSelector : @selector( didSelectedViewMode: ) ] )
    {
        [ delegate performSelector : @selector( didSelectedViewMode: ) withObject : [NSNumber numberWithInt:2] ] ;
    }
}

@end

// SocialProfileButton Class ;
@implementation SocialProfileButton

// Properties ;
@synthesize delegate ;

// Functions ;
#pragma mark - Shared Funtions
+ ( SocialProfileButton* ) sharedView
{
    NSArray*                array   = [ [ NSBundle mainBundle ] loadNibNamed : @"SocialProfileCell" owner : nil options : nil ] ;
    SocialProfileButton*    view    = [ array objectAtIndex : 2 ] ;
    
    return view ;
}

#pragma mark - SocialProfileButton
- ( id ) initWithFrame : ( CGRect ) _frame
{
    self = [ super initWithFrame : _frame ] ;
    
    if( self )
    {
        
    }
    
    return self ;
}

- ( void ) dealloc
{
     
}

- ( void ) awakeFromNib
{
    // Background ;
    UIImage*    imgForNormal            = [ [ UIImage imageNamed : @"cell-multi-mid-default.png" ] resizableImageWithCapInsets : UIEdgeInsetsMake( 11, 13, 11, 13 ) ] ;
    UIImage*    imgForHighlight         = [ [ UIImage imageNamed : @"cell-multi-mid-active.png" ] resizableImageWithCapInsets : UIEdgeInsetsMake( 11, 13, 11, 13 ) ] ;
    
    [ imgForBackground setImage : imgForNormal ] ;
    [ imgForBackground setHighlightedImage : imgForHighlight ] ;
}

@end
