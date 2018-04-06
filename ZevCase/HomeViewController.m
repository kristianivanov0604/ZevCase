//
//  HomeViewController.m
//  ZevCase
//
//  Created by Yu Li on 10/2/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "HomeViewController.h"
#import "GridTableCell.h"
#import "Global.h"
#import "PhoneSelectViewController.h"
#import "SocialCommunication.h"
#import "SocialFeed.h"
#import "SocialUserController.h"
#import "SocialLikeController.h"
#import "SocialCommentController.h"
#import "SocialCartViewController.h"
#import "SocialFeedDetailViewController.h"


#import "SocialFeedCell.h"
#import "SocialMoreCell.h"

@interface HomeViewController (){
    BOOL                navigationBarHidden ;
    
    UIBarButtonItem*    itemForRefresh ;
    UIBarButtonItem*    itemForIndicator ;
    UIActivityIndicatorView* activityIndicator ;
    
    // Feeds ;
    NSMutableArray*     arrForFeed ;
    BOOL                more ;
}

- ( void ) loadFeeds ;

// Events ;
- ( IBAction ) onBtnRefresh : ( id ) _sender ;

@end

@implementation HomeViewController
@synthesize tabView;
@synthesize imageForBlock;
@synthesize imageForMakeCase;


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
    
    [tabView setFrame:CGRectMake(0, 0, self.tabView.frame.size.width, self.tabView.frame.size.height)];
    
    [tblForFeed setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 64- tabView.frame.size.height)];
    
    [self.tabBarController.tabBar addSubview:tabView];
    
    [self.tabBarController.navigationItem setHidesBackButton:YES];
    
    [self.tabBarController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"img_navigationbarback"] forBarMetrics:UIBarMetricsDefault];
    navigationBarHidden     = NO ;
    
    // Feeds ;
    arrForFeed          = [ [ NSMutableArray alloc ] init ] ;
    
    // Refresh Button ;
    itemForRefresh      = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onBtnRefresh:)];
    [itemForRefresh setTintColor:[UIColor whiteColor]];
    
    [ self.navigationItem setRightBarButtonItem : itemForRefresh ] ;
    
    // Activity Indicator ;
    activityIndicator   = [ [ UIActivityIndicatorView alloc ] initWithActivityIndicatorStyle : UIActivityIndicatorViewStyleGray ]  ;
    itemForIndicator    = [ [ UIBarButtonItem alloc ] initWithCustomView : activityIndicator ] ;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [self.navigationItem setTitle:@"ZEV"];
//    [self.navigationItem setRightBarButtonItem:Nil];
    [ self.navigationController setNavigationBarHidden : NO animated : YES ] ;
    [self loadFeeds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- ( IBAction ) onBtnRefresh : ( id ) _sender
{
    [ self loadFeeds ] ;
}

#pragma mark - action
-(IBAction)actionSelectedButton:(id)sender{
    for (int i = 10; i < 14; i++) {
        [(UIButton*)[tabView viewWithTag:i] setSelected:NO];
    }
    
    switch ([(UIButton*)sender tag]) {
        case 10:{
            self.tabBarController.selectedIndex = 0;
            [(UIButton*)sender setSelected:YES];
            break;
        }
        case 11:{
            self.tabBarController.selectedIndex = 1;
            [(UIButton*)sender setSelected:YES];
            break;
        }
        case 12:{
            self.tabBarController.selectedIndex = 2;
            [(UIButton*)sender setSelected:YES];
            break;
        }
        case 13:{
            self.tabBarController.selectedIndex = 3;
            [(UIButton*)sender setSelected:YES];
            break;
        }
        case 14:{
            PhoneSelectViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PhoneSelectViewController"];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
            navController.navigationBarHidden = YES;
            [self.tabBarController presentViewController:navController animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
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
        
        
        if ([arrForFeed count] == 0){
            [imageForMakeCase setHidden:NO];
            [imageForBlock setHidden:NO];
            [imageForMakeCase setCenter:CGPointMake(imageForMakeCase.center.x, self.view.frame.size.height - 20 )];
        }else{
            [imageForMakeCase setHidden:YES];
            [imageForBlock setHidden:YES];
        }
        
        more    = ( [ arrForFeed count ] ) && ( [ arrForFeed count ] % 30 == 0 ) ;
        
        // Reload ;
        [ tblForFeed reloadData ] ;
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        // Refresh ;
        [ activityIndicator stopAnimating ] ;
        [ self.navigationItem setRightBarButtonItem : itemForRefresh ] ;
    } ;
    
    [ [ SocialCommunication sharedManager ] FeedFollows : successed
                                                failure : failure ] ;
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
        return 35.0f ;
    }
    
    return 0 ;
}

- ( UITableViewCell* ) tableView : ( UITableView* ) _tableView cellForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    if( more && _indexPath.section == [ arrForFeed count ] )
    {
        SocialMoreCell*     cell    = [ tblForFeed dequeueReusableCellWithIdentifier : @"SocialMoreCell" ] ;
        
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
    [ tblForFeed reloadData ] ;
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
//    SocialCartViewController *viewController = [[SocialCartViewController alloc] initWithFeed:_feed];
    SocialFeedDetailViewController *viewController = [[SocialFeedDetailViewController alloc] initWithFeed:_feed];
    
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

#pragma mark - UIScrollView Delegate
//- ( void ) scrollViewDidScroll : ( UIScrollView* ) _scrollView
//{
//    CGFloat offset          = tblForFeed.contentOffset.y ;
//    CGRect  barFrame        = naviForFeed.frame ;
//    CGRect  tblFrame        = tblForFeed.frame ;
//    
//    // Navigation Bar ;
//    if( tblFrame.origin.y < barFrame.size.height )
//    {
//        offset += barFrame.size.height - tblFrame.origin.y ;
//    }
//    
//    barFrame.origin.y       = MIN( - offset, 20 ) ;
//    [ naviForFeed setFrame : barFrame ] ;
//    
//    // Table View ;
//    tblFrame.origin.y       = MAX( barFrame.origin.y + barFrame.size.height, 0 ) ;
//    tblFrame.origin.y       = MIN( barFrame.size.height, tblFrame.origin.y ) ;
//    tblFrame.size.height    = self.view.frame.size.height - tblFrame.origin.y;
//    
//    if( !CGRectEqualToRect( tblFrame, _scrollView.frame ) )
//    {
//        tblForFeed.frame = tblFrame ;
//    }
//    
//    if( tblFrame.origin.y > 0 && tblFrame.origin.y < barFrame.size.height )
//    {
//        [ tblForFeed setContentOffset : CGPointZero ] ;
//    }
//    
//    [ tblForFeed setScrollIndicatorInsets : UIEdgeInsetsMake( 64 - tblFrame.origin.y, 0, 0, 0 ) ] ;
//}
//

@end
