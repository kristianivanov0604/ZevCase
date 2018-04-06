//
//  SocialProfileController.m
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import "SocialProfileController.h"
#import "SocialProfileCell.h"
#import "SocialFeedCell.h"

#import "SocialOptionController.h"
#import "SocialEditProfile.h"

#import "SocialFollowerController.h"
#import "SocialFollowingController.h"
#import "SocialUserController.h"
#import "SocialFeedController.h"
#import "SocialLikeController.h"
#import "SocialCommentController.h"

#import "SocialCommunication.h"
#import "SocialUser.h"
#import "SocialUserProfile.h"
#import "SocialFeed.h"

// --- Defines --- ;
// SocialProfileController Class ;
@interface SocialProfileController () < UITableViewDelegate >
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

@implementation SocialProfileController

// Properties;
@synthesize userProfile ;

// Functions ;
#pragma mark - SocialProfileController
- ( id ) initWithNibName : ( NSString* ) _nibNameOrNil bundle : ( NSBundle* ) _nibBundleOrNil
{
    self = [ super initWithNibName : _nibNameOrNil bundle : _nibBundleOrNil ] ;
    
    if( self )
    {

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
    
    // Load ;
    [ self loadProfile ] ;
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
    switch( viewMode )
    {
        case 1 :    // Grid ;
        {
            if( [ arrForFeed count ] )
            {
                return 2 ;
            }
            
            return 1 ;
        }
            
        case 2 :    // List ;
        {
            if( [ arrForFeed count ] )
            {
                return 1 + [ arrForFeed count ] ;
            }
            
            return 1 ;
        }
            
        default :
            break ;
    }
    
    return 0 ;
}

- ( NSInteger ) tableView : ( UITableView* ) _tableView numberOfRowsInSection : ( NSInteger ) _section
{
    // Profile ;
    if( _section == 0 )
    {
        if( [ arrForFeed count ] )
        {
            return 2 ;
        }
    
        return 1 ;
    }
    
    // Feeds ;
    if( _section )
    {
        switch( viewMode )
        {
            case 1 :    // Grid ;
            {
                return ( [ arrForFeed count ] / kNumberOfOneCell ) + ( [ arrForFeed count ] % kNumberOfOneCell ? 1 : 0 ) ;
            }
                
            case 2 :    // List ;
            {
                SocialFeed* feed    = [ arrForFeed objectAtIndex : _section - 1 ] ;
                
                // Row Count ;
                return [ self cellCount : feed ] ;
            }
                
            default :
            {
                return 0 ;
            }
        }
    }
    
    return 0 ;
}

- ( CGFloat ) tableView : ( UITableView* ) _tableView heightForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    // Profile ;
    if( _indexPath.section == 0 )
    {
        switch( _indexPath.row )
        {
            case 0 :
                return 108.0f ;
                
            case 1 :
                return 60.0f ;
                
            default :
                break ;
        }
        
        return 0 ;
    }

    // Feeds ;
    if( _indexPath.section )
    {
        switch( viewMode )
        {
            case 1 :    // Grid ;
            {
                return 103.0f ;
            }
                
            case 2 :    // List ;
            {
                // Feeds ;
                SocialFeed* feed    = [ arrForFeed objectAtIndex : _indexPath.section - 1 ] ;
                
                // User ;
                if( [ self isUserCell : _indexPath.row feed : feed ] )
                {
                    return 45.0f ;
                }
                
                // Photo ;
                if( [ self isPhotoCell : _indexPath.row feed : feed ] )
                {
                    return 306.0f ;
                }
                
                // Likes ;
                if( [ self isLikeCell : _indexPath.row feed : feed ] )
                {
                    return 32.0f ;
                }
                
                // Comments ;
                NSInteger comment   = [ self isCommentCell : _indexPath.row feed : feed ] ;
                
                if( comment >= 0 )
                {
                    return 32.0f ;
                }
                
                // Photo Options ;
                if( [ self isPhotoOptionCell : _indexPath.row feed : feed ] )
                {
                    return 32.0f ;
                }
                
                return 0 ;
            }
                
            default :
                break ;
        }
    }
    
    return 0.0f ;
}

- ( UITableViewCell* ) tableView : ( UITableView* ) _tableView cellForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    // Profile ;
    if( _indexPath.section == 0 )
    {
        switch( _indexPath.row )
        {
            case 0 :
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
                
            case 1 :
            {
                SocialProfileMode*  cell    = [ tblForFeed dequeueReusableCellWithIdentifier : @"SocialProfileMode" ] ;
                
                if( cell == nil )
                {
                    cell    = [ SocialProfileMode sharedCell ] ;
                }
                
                // Set ;
                [ cell setDelegate : self ] ;
                [ cell setViewMode : viewMode ] ;
                
                return cell ;
            }
                
            default :
                break ;
        }
        
        return nil ;
    }
    
    // Feeds ;
    if( _indexPath.section )
    {
        switch( viewMode )
        {
            case 1 :    // Grid ;
            {
                SocialFeedGrid*     cell    = [ tblForFeed dequeueReusableCellWithIdentifier : @"SocialFeedGrid" ] ;
                NSInteger           row     = _indexPath.row ;
                
                if( cell == nil )
                {
                    cell    = [ SocialFeedGrid sharedCell ] ;
                }
                
                // Feeds ;
                [ cell setDelegate : self ] ;
                [ cell setFeed1 : [ arrForFeed objectAtIndex : row * 3 + 0 ] ] ;
                [ cell setFeed2 : row * 3 + 1 < [ arrForFeed count ] ? [ arrForFeed objectAtIndex : row * 3 + 1 ] : nil ] ;
                [ cell setFeed3 : row * 3 + 2 < [ arrForFeed count ] ? [ arrForFeed objectAtIndex : row * 3 + 2 ] : nil ] ;
                
                return cell ;
            }
                
            case 2 :    // List ;
            {
                SocialFeed* feed    = [ arrForFeed objectAtIndex : _indexPath.section - 1 ] ;
                
                // User ;
                if( [ self isUserCell : _indexPath.row feed : feed ] )
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
                if( [ self isPhotoCell : _indexPath.row feed : feed ] )
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
                if( [ self isLikeCell : _indexPath.row feed : feed ] )
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
                NSInteger comment   = [ self isCommentCell : _indexPath.row feed : feed ] ;
                
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
                if( [ self isPhotoOptionCell : _indexPath.row feed : feed ] )
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
                
            default :
                break ;
        }
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

- ( void ) didFollowers
{
    SocialUser*                 me              = [ [ SocialCommunication sharedManager ] me ] ;
    SocialFollowerController*   viewController  = [ [ SocialFollowerController alloc ] initWithUser : me ]  ;
    
    // Push ;
    [ self.navigationController pushViewController : viewController animated : YES ] ;
}

- ( void ) didFollowings
{
    SocialUser*                 me              = [ [ SocialCommunication sharedManager ] me ] ;
    SocialFollowingController*  viewController  = [ [ SocialFollowingController alloc ] initWithUser : me ]  ;
    
    // Push ;
    [ self.navigationController pushViewController : viewController animated : YES ] ;
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
    SocialEditProfile*          viewController  = [ [ SocialEditProfile alloc ] initWithNibName : @"SocialEditProfile" bundle : nil ]  ;
    
    [ viewController setUserProfile : [ self userProfile ] ] ;
    
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
    SocialFeedController*   viewController  = [ [ SocialFeedController alloc ] initWithFeed : _feed ]  ;
    
    // Push ;
    [ self.navigationController pushViewController : viewController animated : YES ] ;
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

#pragma mark - Load
- ( void ) loadController
{
    // Navigation Bar ;
//    [ self.navigationItem setTitle : [ [ [ SocialCommunication sharedManager ] me ] username ] ] ;
    NSString *strTitle = [[[SocialCommunication sharedManager] me] username];
    UILabel *lblTitle = [[UILabel alloc] init];
    [lblTitle setText:strTitle];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [lblTitle setFont:[UIFont systemFontOfSize:16.0]];
    [lblTitle sizeToFit];
    UIView *viewTitle = [[UIView alloc] init];
    [viewTitle addSubview:lblTitle];
    [viewTitle setBackgroundColor:[UIColor clearColor]];
    [self.navigationItem setTitleView:viewTitle];
    
    // Setting Button ;
//    UIBarButtonItem*    btnForSetting   = [ [ UIBarButtonItem alloc ] initWithImage : [ UIImage imageNamed : @"gear.png" ]
//                                                                              style : UIBarButtonItemStyleBordered
//                                                                             target : self
//                                                                             action : @selector( onBtnSetting: ) ] ;
//    
//    [ self.navigationItem setRightBarButtonItem : btnForSetting ] ;

    
    // Background ;
//    [ imgForBackground setBackgroundColor : [ UIColor colorWithPatternImage : [ UIImage imageNamed : @"cell-background.png" ] ] ] ;
    
    // Feeds ;
    arrForFeed  = [ NSMutableArray array ] ;
    
    // View Mode ;
    viewMode    = 1 ;
}

- ( void ) loadProfile
{
    // Sign In ;
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        NSDictionary*   dict = [ _responseObject objectForKey : @"user" ] ;
        SocialUserProfile*  profile = [ [ SocialUserProfile alloc ] initWithDict : dict ]  ;
        
        [ self setUserProfile : profile ] ;
        
        // Feeds ;
        [ self loadFeeds ] ;
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        
    } ;
    
    [ [ SocialCommunication sharedManager ] GetProfile : [ [ [ SocialCommunication sharedManager ] me ] username ]
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
    
    [ [ SocialCommunication sharedManager ] Feeds : [ [ SocialCommunication sharedManager ] me ]
                                        successed : successed
                                          failure : failure ] ;
}

#pragma mark - Events
- ( IBAction ) onBtnSetting : ( id ) _sender
{
    SocialOptionController* viewController  = [ [ SocialOptionController alloc ] initWithNibName : @"SocialOptionController" bundle : nil ]  ;
    
    // Push ;
    [ self.navigationController pushViewController : viewController animated : YES ] ;
}

@end