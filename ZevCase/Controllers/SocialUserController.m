//
//  SocialUserController.m
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import "SocialUserController.h"
#import "SocialProfileCell.h"
#import "SocialFeedCell.h"

#import "SocialFollowerController.h"
#import "SocialFollowingController.h"
#import "SocialUserController.h"
#import "SocialFeedController.h"
#import "SocialFeedDetailViewController.h"
#import "SocialLikeController.h"
#import "SocialCommentController.h"

#import "SocialCommunication.h"
#import "SocialUser.h"
#import "SocialUserProfile.h"
#import "SocialFeed.h"
#import "SocialEditProfile.h"

// --- Defines --- ;
// SocialUserController Class ;
@interface SocialUserController ()
{
    NSInteger       viewMode ;
    NSMutableArray* arrForFeed ;
}

// Load ;
- ( void ) loadController ;
- ( void ) loadProfile ;
- ( void ) loadFeeds ;

// Events ;
- ( IBAction ) onBtnSetting : ( id ) _sender ;

@end

@implementation SocialUserController

// Properties;
@synthesize username ;
@synthesize userProfile ;

// Functions ;
#pragma mark - SocialUserController
- ( id ) initWithNibName : ( NSString* ) _nibNameOrNil bundle : ( NSBundle* ) _nibBundleOrNil
{
    self = [ super initWithNibName : _nibNameOrNil bundle : _nibBundleOrNil ] ;
    
    if( self )
    {
        
    }
    
    return self ;
}

- ( id ) initWithUser : ( SocialUser* ) _user
{
    self = [ super initWithNibName : @"SocialUserController" bundle : nil ] ;
    
    if( self )
    {
        [ self setUsername : [ _user username ] ] ;
    }
    
    return self ;
}

- ( id ) initWithUsername : ( NSString* ) _username
{
    self = [ super initWithNibName : @"SocialUserController" bundle : nil ] ;
    
    if( self )
    {
        [ self setUsername : _username ] ;
    }
    
    return self ;
}

- ( void ) viewDidLoad
{
    [ super viewDidLoad ] ;
    
    // Load ;
    [ self loadController ] ;
    
    
}

- ( void ) viewWillAppear : ( BOOL ) _animated
{
    [ super viewWillAppear : _animated ] ;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];

    // Load ;
    [ self loadProfile ] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- ( void ) didReceiveMemoryWarning
{
    [ super didReceiveMemoryWarning ] ;
}

- ( void ) dealloc
{
    // Release ;
}

#pragma mark - UITableView Delegate
- ( NSInteger ) numberOfSectionsInTableView : ( UITableView* ) _tableView
{
    if( [ arrForFeed count ] )
    {
        return 2 ;
    }
    
    return 1 ;
}

- ( NSInteger ) tableView : ( UITableView* ) _tableView numberOfRowsInSection : ( NSInteger ) _section
{
    // Profile ;
    if( _section == 0 )
    {
        
        return 1 ;
    }
    
    // Feeds ;
    if( _section )
    {
        return ( [ arrForFeed count ] / kNumberOfOneCell ) + ( [ arrForFeed count ] % kNumberOfOneCell ? 1 : 0 ) ;
    }
    
    return 0 ;
}

- ( CGFloat ) tableView : ( UITableView* ) _tableView heightForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    // Profile ;
    if( _indexPath.section == 0 )
    {
        return 280.0f ;
    }
    
    // Feeds ;
    if( _indexPath.section )
    {
        return 220.0f ;
    }
    
    return 0.0f ;
}

- ( UITableViewCell* ) tableView : ( UITableView* ) _tableView cellForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    // Profile ;
    if( _indexPath.section == 0 )
    {
        SocialProfileUser*  cell    = [ tblForFeed dequeueReusableCellWithIdentifier : @"SocialProfileUser" ] ;
        
        if( cell == nil )
        {
            cell    = [ SocialProfileUser sharedCell ] ;
        }
        
        // Set ;
        [ cell setDelegate : self ] ;
        [ cell setUserProfile : [ self userProfile ] ] ;
        
        return cell ;
    }
    
    // Feeds ;
    if( _indexPath.section )
    {
        SocialFeedGrid*     cell    = [ tblForFeed dequeueReusableCellWithIdentifier : @"SocialFeedGrid" ] ;
        NSInteger           row     = _indexPath.row ;
        
        if( cell == nil )
        {
            cell    = [ SocialFeedGrid sharedCell ] ;
        }
        
        // Feeds ;
        [ cell setDelegate : self ] ;
        [ cell setFeed1 : [ arrForFeed objectAtIndex : row * kNumberOfOneCell + 0 ] ] ;
        [ cell setFeed2 : row * kNumberOfOneCell + 1 < [ arrForFeed count ] ? [ arrForFeed objectAtIndex : row * kNumberOfOneCell + 1 ] : nil ] ;
//        [ cell setFeed3 : row * 3 + 2 < [ arrForFeed count ] ? [ arrForFeed objectAtIndex : row * 3 + 2 ] : nil ] ;
        
        return cell ;
        
    }
    
    return nil ;
}

- ( void ) tableView : ( UITableView* ) _tableView didSelectRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    
}

#pragma mark - Actions
- ( void ) didPhotos
{
    
}

- ( void ) didEditProfile
{
    SocialEditProfile*          viewController  = [ [ SocialEditProfile alloc ] initWithNibName : @"SocialEditProfile" bundle : nil ]  ;
    
    [ viewController setUserProfile : [ self userProfile ] ] ;
    
    // Push ;
    [ self.navigationController pushViewController : viewController animated : YES ] ;
}

- ( void ) didFollowProfile
{
    [self loadProfile];
}

- ( void ) didFollowers
{
    SocialFollowerController*   viewController  = [ [ SocialFollowerController alloc ] initWithUser : [ self userProfile ] ]  ;
    
    // Push ;
    [ self.navigationController pushViewController : viewController animated : YES ] ;
}

- ( void ) didFollowings
{
    SocialFollowingController*  viewController  = [ [ SocialFollowingController alloc ] initWithUser : [ self userProfile ] ]  ;
    
    // Push ;
    [ self.navigationController pushViewController : viewController animated : YES ] ;
}

- ( void ) didSelectedUser : ( SocialUser* ) _user
{
    SocialUserController*       viewController = [ [ SocialUserController alloc ] initWithUser : _user ]  ;
    
    // Push ;
    [ self.navigationController pushViewController : viewController animated : YES ] ;
}

- ( void ) didLikes : ( SocialFeed* ) _feed
{
    SocialLikeController*    viewController = [ [ SocialLikeController alloc ] initWithFeed : _feed ]  ;
    
    // Push ;
    [ self.navigationController pushViewController : viewController animated : YES ] ;
}

- ( void ) didLikedFeed : ( SocialFeed* ) _feed
{
    [ tblForFeed reloadData ] ;
}

- ( void ) didComment : ( SocialFeed* ) _feed
{
    SocialCommentController*    viewController = [ [ SocialCommentController alloc ] initWithFeed : _feed ]  ;
    
    // Push ;
    [ self.navigationController pushViewController : viewController animated : YES ] ;
}

- ( void ) didOptions : ( SocialFeed* ) _feed
{
    
}

- ( void ) didSelectedFeed : ( SocialFeed* ) _feed
{
//    SocialFeedController*   viewController  = [ [ SocialFeedController alloc ] initWithFeed : _feed ]  ;
    
    SocialFeedDetailViewController *viewController = [[SocialFeedDetailViewController alloc] initWithFeed:_feed];
    
    // Push ;
    [ self.navigationController pushViewController : viewController animated : YES ] ;
}

- (void) didBackButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Cell
- ( NSInteger ) cellCount : ( SocialFeed* ) _feed
{
    NSInteger   rows    = 0 ;
    
    // User ;
    rows += 1 ;
    
    // Photo ;
    rows += 1 ;
    
    // Likes ;
    rows += [ _feed likes ] ? 1 : 0 ;
    
    // Comments ;
    rows += [ _feed comments ] > 5 ? 5 : [ _feed comments ] ;
    
    // Photo Options ;
    rows += 1 ;
    
    return rows ;
}

- ( BOOL ) isUserCell : ( NSInteger ) _row feed : ( SocialFeed* ) _feed
{
    return ( _row == 0 ) ;
}

- ( BOOL ) isPhotoCell : ( NSInteger ) _row feed : ( SocialFeed* ) _feed
{
    return ( _row == 1 ) ;
}

- ( BOOL ) isLikeCell : ( NSInteger ) _row feed : ( SocialFeed* ) _feed
{
    return ( _row == 2 ) && [ _feed likes ] ;
}

- ( NSInteger ) isCommentCell : ( NSInteger ) _row feed : ( SocialFeed* ) _feed
{
    NSInteger likes     = [ _feed likes ] ? 1 : 0 ;
    NSInteger comments  = [ _feed comments ] > 5 ? 5 : [ _feed comments ] ;
    NSInteger comment   = _row - 2 - likes ;
    
    if( comment >= 0 && comment < comments )
    {
        return comment ;
    }
    
    return -1 ;
}

- ( BOOL ) isPhotoOptionCell : ( NSInteger ) _row feed : ( SocialFeed* ) _feed
{
    NSInteger likes     = [ _feed likes ] ? 1 : 0 ;
    NSInteger comments  = [ _feed comments ] > 5 ? 5 : [ _feed comments ] ;
    NSInteger row       = _row - 2 - likes - comments ;
    
    return row == 0 ;
}

#pragma mark - ViewMode
- ( void ) didSelectedViewMode : ( NSInteger ) _mode
{
    viewMode    = _mode ;
    
    // Reload ;
    [ tblForFeed reloadData ] ;
}

#pragma mark - Alert Tips
- ( void ) showAlertTips : ( NSString* ) _message
{
    UIAlertView*    alertView   = [ [ UIAlertView alloc ] initWithTitle : ALERT_TIPS
                                                                  message : _message
                                                                 delegate : self
                                                        cancelButtonTitle : @"Ok"
                                                        otherButtonTitles : nil, nil ]  ;
    
    // Show ;
    [ alertView show ] ;
}

- ( void ) alertView : ( UIAlertView* ) _alertView clickedButtonAtIndex : ( NSInteger ) _buttonIndex
{
    if( [ _alertView.title isEqualToString : ALERT_TIPS ] )
    {
        [ self.navigationController popViewControllerAnimated : YES ] ;
    }
}

#pragma mark - Load
- ( void ) loadController
{
    // Navigation Bar ;
//    [ self.navigationItem setTitle : [ self username ] ] ;
    NSString *strTitle = [self username];
    UILabel *lblTitle = [[UILabel alloc] init];
    [lblTitle setText:strTitle];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [lblTitle setFont:[UIFont systemFontOfSize:18.0]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    UIView *viewTitle = [[UIView alloc] init];
    [viewTitle addSubview:lblTitle];
    [viewTitle setBackgroundColor:[UIColor clearColor]];
    [viewTitle setFrame:CGRectMake(0, 0, 120, 30)];
    [lblTitle setFrame:CGRectMake(0, 0, 120, 30)];
    [self.navigationItem setTitleView:viewTitle];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    [tblForFeed setFrame:CGRectMake(0, 64, 320, self.view.frame.size.height - 64 - self.tabBarController.tabBar.frame.size.height)];
    // Feeds ;
    arrForFeed  = [ [ NSMutableArray alloc ] init ] ;
    
    // View Mode ;
    viewMode    = 1 ;
}

- ( void ) loadProfile
{
    // Sign In ;
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        if( [ [ _responseObject objectForKey : @"result" ] isEqualToString : @"failed" ] )
        {
            [ self  showAlertTips : [ _responseObject objectForKey : @"message" ] ] ;
            return ;
        }

        NSDictionary*   dict = [ _responseObject objectForKey : @"user" ] ;
        SocialUserProfile*  profile = [ [ SocialUserProfile alloc ] initWithDict : dict ]  ;
        
        [ self setUserProfile : profile ] ;
        
        // Feeds ;
        [ arrForFeed removeAllObjects ] ;
        
        // Reload ;
        [ tblForFeed reloadData ] ;
        
        // Feeds ;
        [ self loadFeeds ] ;
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        
    } ;
    
    [ [ SocialCommunication sharedManager ] GetProfile : [ self username ]
                                             successed : successed
                                               failure : failure ] ;
}

- ( void ) loadFeeds
{
    // Sign In ;
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        // Feeds ;
        [ arrForFeed removeAllObjects ] ;
        
        for( NSDictionary* dict in _responseObject )
        {
            SocialFeed* feed    = [ [ SocialFeed alloc ] initWithDict : dict ]  ;
            
            // Add ;
            [ arrForFeed addObject : feed ] ;
        }
        
//      more    = ( [ arrForFeed count ] ) && ( [ arrForFeed count ] % 30 == 0 ) ;
        
        // Reload ;
        [ tblForFeed reloadData ] ;
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        
    } ;
    
    [ [ SocialCommunication sharedManager ] Feeds : [ self userProfile ]
                                        successed : successed
                                          failure : failure ] ;
}

#pragma mark - Events
- ( IBAction ) onBtnSetting : ( id ) _sender
{
    
}

@end