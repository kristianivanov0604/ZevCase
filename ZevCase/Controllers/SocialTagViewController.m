//
//  SocialTagViewController.m
//  ZevCase
//
//  Created by Yu Li on 12/22/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "SocialTagViewController.h"
#import "SocialProfileCell.h"
#import "SocialFeedCell.h"

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
#import "SocialMoreCell.h"
#import "SocialCartViewController.h"

@interface SocialTagViewController (){
    BOOL                        navigationBarHidden ;
    
    UIBarButtonItem*            itemForRefresh ;
    UIBarButtonItem*            itemForIndicator ;
    UIActivityIndicatorView*    activityIndicator ;
    
    // Feeds ;
    NSMutableArray*     arrForFeed ;
    BOOL                more ;
}

- ( void ) loadFeeds ;

// Events ;
- ( IBAction ) onBtnRefresh : ( id ) _sender ;
- ( IBAction ) onBtnBack : ( id ) _sender ;

@end

@implementation SocialTagViewController
@synthesize tag;

- ( id ) initWithTag:(NSString *)_tag
{
    self = [ super initWithNibName : @"SocialTagViewController" bundle : nil ] ;
    
    if( self )
    {
        [ self setTag : _tag ] ;
    }
    
    return self ;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
//    arrForFeed          = [ [ NSMutableArray alloc ] init ] ;
//    
    // Refresh Button ;
    itemForRefresh      = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onBtnRefresh:)];
    [itemForRefresh setTintColor:[UIColor whiteColor]];
    [self loadController];

    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self loadController];
    [self loadFeeds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Events ;
- ( IBAction ) onBtnRefresh : ( id ) _sender {
    [self loadFeeds];
}
- ( IBAction ) onBtnBack : ( id ) _sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- ( void ) loadController
{
    // Navigation Bar ;
    
    NSString *strTitle = tag;
    UILabel *lblTitle = [[UILabel alloc] init];
    [lblTitle setText:strTitle];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [lblTitle setFont:[UIFont systemFontOfSize:18.0]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    //    [lblTitle sizeToFit];
    UIView *viewTitle = [[UIView alloc] init];
    [viewTitle addSubview:lblTitle];
    [viewTitle setBackgroundColor:[UIColor clearColor]];
    [viewTitle setFrame:CGRectMake(0, 0, 140, 30)];
    [lblTitle setFrame:CGRectMake(0, 0, 140, 30)];
    [self.navigationItem setTitleView:viewTitle];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    
    // Activity Indicator ;
    activityIndicator   = [ [ UIActivityIndicatorView alloc ] initWithActivityIndicatorStyle : UIActivityIndicatorViewStyleWhite ]  ;
    itemForIndicator    = [ [ UIBarButtonItem alloc ] initWithCustomView : activityIndicator ]  ;
    
    [ self.navigationItem setRightBarButtonItem : itemForIndicator ] ;
    [ activityIndicator startAnimating ] ;
    
    // Array ;
    arrForFeed  = [ NSMutableArray array ] ;
}

#pragma mark - loadfeeds
- ( void ) loadFeeds
{
    if( [ [ SocialCommunication sharedManager ] me ] == nil )
    {
        return ;
    }
    
    // Refresh ;
    [ self.navigationItem setRightBarButtonItem : itemForIndicator ] ;
    [ activityIndicator startAnimating ] ;
    
    // Sign In ;
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        // Refresh ;
        [ activityIndicator stopAnimating ] ;
        [ self.navigationItem setRightBarButtonItem : itemForRefresh ] ;
        
        // Feeds ;
        [ arrForFeed removeAllObjects ] ;
        
        for( NSDictionary* dict in _responseObject )
        {
            SocialFeed* feed    = [ [ SocialFeed alloc ] initWithDict : dict ]  ;
            
            // Add ;
            [ arrForFeed addObject : feed ] ;
        }
        
        more    = ( [ arrForFeed count ] ) && ( [ arrForFeed count ] % 30 == 0 ) ;
        
        // Reload ;
        [ tableForTag reloadData ] ;
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        // Refresh ;
        [ activityIndicator stopAnimating ] ;
        [ self.navigationItem setRightBarButtonItem : itemForRefresh ] ;
    } ;
    
    [ [ SocialCommunication sharedManager ] FeedTag:tag
                                          successed:successed
                                            failure:failure ] ;
}

#pragma mark - UITableView Delegate
- ( NSInteger ) numberOfSectionsInTableView : ( UITableView* ) _tableView
{
    if( more )
    {
        return [ arrForFeed count ] + 1 ;
    }
    
    return [ arrForFeed count ] ;
}

- ( CGFloat ) tableView : ( UITableView* ) _tableView heightForHeaderInSection : ( NSInteger ) _section
{
    if( more && _section == [ arrForFeed count ] )
    {
        return 0.0f ;
    }
    
    // --- Header --- ;
    return 45.0f ;
}

- ( UIView* ) tableView : ( UITableView* ) _tableView viewForHeaderInSection : ( NSInteger ) _section
{
    if( more && _section == [ arrForFeed count ] )
    {
        return nil ;
    }
    
    // --- Header --- ;
    SocialFeedUser*     view    = [ _tableView dequeueReusableCellWithIdentifier : @"SocialFeedUser" ] ;
    
    if( view == nil )
    {
        view    = [ SocialFeedUser sharedCell ] ;
    }
    
    // Feed ;
    [ view setDelegate : self ] ;
    [ view setFeed : [ arrForFeed objectAtIndex : _section ] ] ;
    
    return view ;
}

- ( NSInteger ) tableView : ( UITableView* ) _tableView numberOfRowsInSection : ( NSInteger ) _section
{
    if( more && _section == [ arrForFeed count ] )
    {
        return 1 ;
    }
    
    // --- Cells --- ;
    SocialFeed*     feed    = [ arrForFeed objectAtIndex : _section ] ;
    
    return [ self cellCount : feed ] ;
}

- ( CGFloat ) tableView : ( UITableView* ) _tableView heightForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    if( more && _indexPath.section == [ arrForFeed count ] )
    {
        return 72.0f ;
    }
    
    // --- Cells --- ;
    SocialFeed* feed    = [ arrForFeed objectAtIndex : _indexPath.section ] ;
    
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
        return [ SocialFeedComment height : [ [ feed commentArray ] objectAtIndex : comment ] ] ;
    }
    
    // Photo Options ;
    if( [ self isPhotoOptionCell : _indexPath.row feed : feed ] )
    {
        return 50.0f ;
    }
    
    return 0 ;
}

- ( UITableViewCell* ) tableView : ( UITableView* ) _tableView cellForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    if( more && _indexPath.section == [ arrForFeed count ] )
    {
        SocialMoreCell*     cell    = [ tableForTag dequeueReusableCellWithIdentifier : @"SocialMoreCell" ] ;
        
        if( cell == nil )
        {
            cell    = [ SocialMoreCell sharedCell ] ;
        }
        
        [ cell startAnimation ] ;
        //        [ self performSelector : @selector( loadMore ) withObject : nil afterDelay : 3.0f ] ;
        
        return cell ;
    }
    
    // --- Cells --- ;
    SocialFeed* feed    = [ arrForFeed objectAtIndex : _indexPath.section ] ;
    
    // Photo ;
    if( [ self isPhotoCell : _indexPath.row feed : feed ] )
    {
        SocialFeedPhoto*     cell    = [ tableForTag dequeueReusableCellWithIdentifier : @"SocialFeedPhoto" ] ;
        
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
        SocialFeedLikes*    cell    = [ tableForTag dequeueReusableCellWithIdentifier : @"SocialFeedLikes" ] ;
        
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
        SocialFeedDetail*   cell    = [ tableForTag dequeueReusableCellWithIdentifier : @"SocialFeedDetail" ] ;
        
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

- ( void ) tableView : ( UITableView* ) _tableView didSelectRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    
}

#pragma mark - Actions
- ( void ) didSelectedUser : ( SocialUser* ) _user
{
    SocialUserController*       viewController = [ [ SocialUserController alloc ] initWithUser : _user ]  ;
    
    navigationBarHidden = YES ;
    
    // Push ;
    [ self.navigationController pushViewController : viewController animated : YES ] ;
}

- ( void ) didSelectedUsername : ( NSString* ) _username
{
    SocialUserController*       viewController = [ [ SocialUserController alloc ] initWithUsername : _username ]  ;
    
    navigationBarHidden = YES ;
    
    // Push ;
    [ self.navigationController pushViewController : viewController animated : YES ] ;
}

- ( void ) didLikes : ( SocialFeed* ) _feed
{
    SocialLikeController*    viewController = [ [ SocialLikeController alloc ] initWithFeed : _feed ]  ;
    
    navigationBarHidden = YES ;
    
    // Push ;
    [ self.navigationController pushViewController : viewController animated : YES ] ;
}

- ( void ) didLikedFeed : ( SocialFeed* ) _feed
{
    [ tableForTag reloadData ] ;
}

- ( void ) didComment : ( SocialFeed* ) _feed
{
    SocialCommentController*    viewController = [ [ SocialCommentController alloc ] initWithFeed : _feed ]  ;
    
    // Navigation Bar ;
    navigationBarHidden = YES ;
    
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

- ( BOOL ) isPhotoCell : ( NSInteger ) _row feed : ( SocialFeed* ) _feed
{
    return ( _row == 0 ) ;
}

- ( BOOL ) isLikeCell : ( NSInteger ) _row feed : ( SocialFeed* ) _feed
{
    return ( _row == 1 ) && [ _feed likes ] ;
}

- ( NSInteger ) isCommentCell : ( NSInteger ) _row feed : ( SocialFeed* ) _feed
{
    NSInteger likes     = [ _feed likes ] ? 1 : 0 ;
    NSInteger comments  = [ _feed comments ] > 5 ? 5 : [ _feed comments ] ;
    NSInteger comment   = _row - 1 - likes ;
    
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
    NSInteger row       = _row - 1 - likes - comments ;
    
    return row == 0 ;
}

@end
