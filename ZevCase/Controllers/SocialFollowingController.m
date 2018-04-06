//
//  SocialFollowingController.m
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import "SocialFollowingController.h"
#import "SocialFollowCell.h"

#import "SocialCommunication.h"
#import "SocialUser.h"
#import "SocialFollow.h"
#import "SocialUserController.h"

// --- Defines --- ;
// SocialFollowingController Class ;
@interface SocialFollowingController ()
{
    NSMutableArray*     arrForFollow ;
}

// Load ;
- ( void ) loadController ;
- ( void ) loadFollowings ;

@end

@implementation SocialFollowingController

// Properties ;
@synthesize user ;

// Functions ;
#pragma mark - SocialFollowingController
- ( id ) initWithUser : ( SocialUser* ) _user
{
    self = [ self initWithNibName : @"SocialFollowingController" bundle : nil ] ;
    
    if( self )
    {
        [ self setUser : _user ] ;
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
    
    [self loadFollowings];
}

- ( void ) didReceiveMemoryWarning
{
    [ super didReceiveMemoryWarning ] ;
}

- ( void ) dealloc
{
    // Release ;
    
}

#pragma mark - Table Delegate
- ( NSInteger ) tableView : ( UITableView* ) _tableView numberOfRowsInSection : ( NSInteger ) _section
{
    return [ arrForFollow count ] ;
}

- ( CGFloat ) tableView : ( UITableView* ) _tableView heightForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    return 50.0f ;
}

- ( UITableViewCell* ) tableView : ( UITableView* ) _tableView cellForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    SocialFollowCell*   cell    = [ tblForFollowing dequeueReusableCellWithIdentifier : @"SocialFollowCell" ] ;
     
    if( cell == nil )
    {
        cell = [ SocialFollowCell sharedCell ] ;
    }
    
    [ cell setDelegate : self ] ;
    [ cell setFollow : [ arrForFollow objectAtIndex : _indexPath.row ] ] ;
    
    return cell ;
}

- ( void ) tableView : ( UITableView* ) _tableView didSelectRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
/*  joltFeedController* viewController  = [ [ joltFeedController alloc ] initWithUser : [ arrForFollow objectAtIndex : _indexPath.row ] ] ; ;
    
    [ self.navigationController pushViewController : viewController animated : YES ] ;
    [ viewController release ] ; */
}

- ( void ) didFollow : ( SocialFollow* ) _follow
{
    [ _follow setFollowing : ![ _follow following ] ] ;
    [ tblForFollowing reloadData ] ;
    
    if( [ _follow following ] )
    {
        [ [ SocialCommunication sharedManager ] FollowingAdd : _follow
                                                   successed : nil
                                                     failure : nil ] ;
    }
    else
    {
        [ [ SocialCommunication sharedManager ] FollowingRemove : _follow
                                                      successed : nil
                                                        failure : nil ] ;
    }
}

- ( void ) didSelectedUser : ( SocialUser* ) _user{
    SocialUserController*       viewController = [ [ SocialUserController alloc ] initWithUser : _user ]  ;
    
    // Push ;
    [ self.navigationController pushViewController : viewController animated : YES ] ;
}

#pragma mark - Load
- ( void ) loadController
{
    // Navigation Bar ;
    
    NSString *strTitle = @"Followings";
    UILabel *lblTitle = [[UILabel alloc] init];
    [lblTitle setText:strTitle];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [lblTitle setFont:[UIFont systemFontOfSize:18.0]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    //    [lblTitle sizeToFit];
    UIView *viewTitle = [[UIView alloc] init];
    [viewTitle addSubview:lblTitle];
    [viewTitle setBackgroundColor:[UIColor clearColor]];
    [viewTitle setFrame:CGRectMake(0, 0, 100, 30)];
    [lblTitle setFrame:CGRectMake(0, 0, 100, 30)];
    [self.navigationItem setTitleView:viewTitle];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    arrForFollow = [NSMutableArray array];
    // Background ;
//  [ imgForBackground setBackgroundColor : [ UIColor colorWithPatternImage : [ UIImage imageNamed : @"cell-background.png" ] ] ] ;
}

- ( void ) loadFollowings
{
    // Followings ;
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        
        [arrForFollow removeAllObjects];
        
        for( NSDictionary* dict in _responseObject )
        {
            
            SocialFollow*    follow  = [ [ SocialFollow alloc ] initWithDict : dict ]  ;
            
            // Add ;
            [ arrForFollow addObject : follow ] ;
        }
        
        // Reload ;
        [ tblForFollowing reloadData ] ;
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        
        // Reload ;
        [ tblForFollowing reloadData ] ;
    } ;
    
    [ [ SocialCommunication sharedManager ] Followings : [ self user ]
                                             successed : successed
                                               failure : failure ] ;
}

@end