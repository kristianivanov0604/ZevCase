//
//  SocialLikeController.m
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import "SocialLikeController.h"
#import "SocialLikeCell.h"

#import "SocialUserController.h"

#import "SocialCommunication.h"
#import "SocialFeed.h"
#import "SocialLike.h"

// --- Defines --- ;
// SocialLikeController Class ;
@interface SocialLikeController ()
{
    NSMutableArray*     arrForLike ;
}

// Load ;
- ( void ) loadController ;
- ( void ) loadLikes ;

@end

@implementation SocialLikeController

// Properties ;
@synthesize feed ;

// Functions ;
#pragma mark - SocialLikeController
- ( id ) initWithFeed : ( SocialFeed* ) _feed
{
    self = [ self initWithNibName : @"SocialLikeController" bundle : nil ] ;
    
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

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadLikes];
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
    return [ arrForLike count ] ;
}

- ( CGFloat ) tableView : ( UITableView* ) _tableView heightForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    return 44.0f ;
}

- ( UITableViewCell* ) tableView : ( UITableView* ) _tableView cellForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    SocialLikeCell*     cell    = [ tblForLike dequeueReusableCellWithIdentifier : @"SocialLikeCell" ] ;
    
    if( cell == nil )
    {
        cell = [ SocialLikeCell sharedCell ] ;
    }
    
    // Like ;
    [ cell setLike : [ arrForLike objectAtIndex : _indexPath.row ] ] ;
    
    return cell ;
}

- ( void ) tableView : ( UITableView* ) _tableView didSelectRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    SocialUserController*   viewController = [ [ SocialUserController alloc ] initWithUser : [ arrForLike objectAtIndex : _indexPath.row ] ]  ;
    
    // Push ;
    [ self.navigationController pushViewController : viewController animated : YES ] ;
}

#pragma mark - Load
- ( void ) loadController
{
    // Navigation Bar ;
    
    NSString *strTitle = @"Likers";
    UILabel *lblTitle = [[UILabel alloc] init];
    [lblTitle setText:strTitle];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [lblTitle setFont:[UIFont systemFontOfSize:18.0]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    //    [lblTitle sizeToFit];
    UIView *viewTitle = [[UIView alloc] init];
    [viewTitle addSubview:lblTitle];
    [viewTitle setBackgroundColor:[UIColor clearColor]];
    [viewTitle setFrame:CGRectMake(0, 0, 80, 30)];
    [lblTitle setFrame:CGRectMake(0, 0, 80, 30)];
    [self.navigationItem setTitleView:viewTitle];
    
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // Activity Indicator ;
    UIActivityIndicatorView*    activityIndicator   = [ [ UIActivityIndicatorView alloc ] initWithActivityIndicatorStyle : UIActivityIndicatorViewStyleWhite ]  ;
    UIBarButtonItem*            itemForIndicator    = [ [ UIBarButtonItem alloc ] initWithCustomView : activityIndicator ]  ;
    
    [ self.navigationItem setRightBarButtonItem : itemForIndicator ] ;
    [ activityIndicator startAnimating ] ;
    
    // Array ;
    arrForLike  = [ [ NSMutableArray alloc ] init ] ;
}

- ( void ) loadLikes
{
    if( [ [ SocialCommunication sharedManager ] me ] == nil )
    {
        return ;
    }
    
    // Like ;
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        // Refresh ;
        [ self.navigationItem setRightBarButtonItem : nil ] ;
        
        // Feeds ;
        [ arrForLike removeAllObjects ] ;
        
        for( NSDictionary* dict in _responseObject )
        {
            SocialLike* like    = [ [ SocialLike alloc ] initWithDict : dict ]  ;
            
            // Add ;
            [ arrForLike addObject : like ] ;
        }
        
        // Reload ;
        [ tblForLike reloadData ] ;
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        // Refresh ;
        [ self.navigationItem setRightBarButtonItem : nil ] ;
        
        // Likes ;
        [ arrForLike removeAllObjects ] ;
        
        // Reload ;
        [ tblForLike reloadData ] ;
    } ;
    
    [ [ SocialCommunication sharedManager ] Likes : [ self feed ]
                                        successed : successed
                                          failure : failure ] ;
}

@end