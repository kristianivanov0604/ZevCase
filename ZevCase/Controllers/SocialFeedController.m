//
//  SocialFeedController.m
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import "SocialFeedController.h"
#import "SocialUserController.h"
#import "SocialLikeController.h"
#import "SocialCommentController.h"
#import "SocialCartViewController.h"

#import "SocialFeedCell.h"
#import "SocialMoreCell.h"

#import "SocialCommunication.h"
#import "SocialFeed.h"

// --- Defines --- ;
// SocialFeedController Class ;
@interface SocialFeedController ()

// Load ;
- ( void ) loadController ;

// Events ;
- ( IBAction ) onBtnRefresh : ( id ) _sender ;

@end

@implementation SocialFeedController

// Properties ;
@synthesize feed ;

// Functions ;
#pragma mark - SocialFeedController
- ( id ) initWithFeed : ( SocialFeed* ) _feed
{
    self = [ self initWithNibName : @"SocialFeedController" bundle : nil ] ;
    
    if( self )
    {
        [ self setFeed : _feed ] ;
    }
    
    return self ;
}

- ( void ) viewDidLoad
{
    [ super viewDidLoad ] ;
    
    // Load ;
    [ self loadController ] ;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ tblForFeed reloadData ] ;
}

- ( void ) didReceiveMemoryWarning
{
    [ super didReceiveMemoryWarning ] ;
}

- ( void ) dealloc
{
    // Release ;
    [ self setFeed : nil ] ;
    
}

#pragma mark - Table Delegate
- ( NSInteger ) numberOfSectionsInTableView : ( UITableView* ) _tableView
{
    return 1 ;
}

- ( NSInteger ) tableView : ( UITableView* ) _tableView numberOfRowsInSection : ( NSInteger ) _section
{
    // --- Cells --- ;
    return [ self cellCount : [ self feed ] ] ;
}

- ( CGFloat ) tableView : ( UITableView* ) _tableView heightForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    // --- Cells --- ;
    // User ;
    if( [ self isUserCell : _indexPath.row feed : [ self feed ] ] )
    {
        return 45.0f ;
    }
    
    // Photo ;
    if( [ self isPhotoCell : _indexPath.row feed : [ self feed ] ] )
    {
        return 306.0f ;
    }
    
    // Likes ;
    if( [ self isLikeCell : _indexPath.row feed : [ self feed ] ] )
    {
        return 32.0f ;
    }
    
    // Comments ;
    NSInteger comment   = [ self isCommentCell : _indexPath.row feed : [ self feed ] ] ;
    
    if( comment >= 0 )
    {
        return 32.0f ;
    }
    
    // Photo Options ;
    if( [ self isPhotoOptionCell : _indexPath.row feed : [ self feed ] ] )
    {
        return 50.0f ;
    }
    
    return 0 ;
}

- ( UITableViewCell* ) tableView : ( UITableView* ) _tableView cellForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    // --- Cells --- ;
    // User ;
    if( [ self isUserCell : _indexPath.row feed : [ self feed ] ] )
    {
        SocialFeedUser*     cell    = [ tblForFeed dequeueReusableCellWithIdentifier : @"SocialFeedUser" ] ;
        
        if( cell == nil )
        {
            cell    = [ SocialFeedUser sharedCell ] ;
        }
        
        // Feed ;
        [ cell setDelegate : self ] ;
        [ cell setFeed : feed ] ;
        
        return cell ;
    }
    
    // Photo ;
    if( [ self isPhotoCell : _indexPath.row feed : [ self feed ] ] )
    {
        SocialFeedPhoto*     cell    = [ tblForFeed dequeueReusableCellWithIdentifier : @"SocialFeedPhoto" ] ;
        
        if( cell == nil )
        {
            cell    = [ SocialFeedPhoto sharedCell ] ;
        }
        
        // Feed ;
        [ cell setDelegate : self ] ;
        [ cell setFeed : feed ] ;
        
        return cell ;
    }
    
    // Likes ;
    if( [ self isLikeCell : _indexPath.row feed : [ self feed ] ] )
    {
        SocialFeedLikes*    cell    = [ tblForFeed dequeueReusableCellWithIdentifier : @"SocialFeedLikes" ] ;
        
        if( cell == nil )
        {
            cell    = [ SocialFeedLikes sharedCell ] ;
        }
        
        // Feed ;
        [ cell setDelegate : self ] ;
        [ cell setFeed : feed ] ;
        
        return cell ;
    }
    
    // Comments ;
    NSInteger comment   = [ self isCommentCell : _indexPath.row feed : [ self feed ] ] ;
    
    if( comment >= 0 )
    {
        SocialFeedComment*  cell    = [ _tableView dequeueReusableCellWithIdentifier : @"SocialFeedComment" ] ;
        
        if( cell == nil )
        {
            cell    = [ SocialFeedComment sharedCell ] ;
        }
        
        // Comment ;
        [ cell setDelegate : self ] ;
        [ cell setComment : [ [ feed commentArray ] objectAtIndex : comment ] ] ;
        
        return cell ;
    }
    
    // Photo Options ;
    if( [ self isPhotoOptionCell : _indexPath.row feed : [ self feed ] ] )
    {
        SocialFeedDetail*   cell    = [ tblForFeed dequeueReusableCellWithIdentifier : @"SocialFeedDetail" ] ;
        
        if( cell == nil )
        {
            cell    = [ SocialFeedDetail sharedCell ] ;
        }
        
        // Feed ;
        [ cell setDelegate : self ] ;
        [ cell setFeed : feed ] ;
        
        return cell ;
    }
    
    return nil ;
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
    
    SocialCartViewController *viewController = [[SocialCartViewController alloc] initWithFeed:_feed];
    [self.navigationController pushViewController:viewController animated:YES];
    
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

#pragma mark - Load
- ( void ) loadController
{
    // Navigation Bar ;
    
    NSString *strTitle = [NSString stringWithFormat:@"%@", feed.name];
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
}

#pragma mark - Events
- ( IBAction ) onBtnRefresh : ( id ) _sender
{
    [ tblForFeed reloadData ] ;
}

@end