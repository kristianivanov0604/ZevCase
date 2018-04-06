//
//  SearchViewController.m
//  ZevCase
//
//  Created by Yu Li on 10/2/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "SearchViewController.h"
#import "SocialFeedCell.h"

#import "SocialFeedController.h"
#import "SocialFeedDetailViewController.h"

#import "SocialCommunication.h"
#import "SocialFeed.h"

#import "SocialTagViewController.h"



@interface SearchViewController (){
    UIBarButtonItem*    itemForRefresh ;
    UIBarButtonItem*    itemForIndicator ;
    UIActivityIndicatorView* activityIndicator ;
    
    // Feeds ;
    NSMutableArray*     arrForFeed ;
    NSMutableArray*     arrForSearch ;
    
}

- ( void ) loadFeeds ;

// Events ;
- ( IBAction ) onBtnRefresh : ( id ) _sender ;


@end

@implementation SearchViewController


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
    
//    [ self.navigationItem setTitle : @"Explore" ] ;
    
    // Refresh Button ;
    itemForRefresh      = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onBtnRefresh:)];
    [itemForRefresh setTintColor:[UIColor whiteColor]];
    
    [ self.navigationItem setRightBarButtonItem : itemForRefresh ] ;
    
    // Activity Indicator ;
    activityIndicator   = [ [ UIActivityIndicatorView alloc ] initWithActivityIndicatorStyle : UIActivityIndicatorViewStyleGray ]  ;
    itemForIndicator    = [ [ UIBarButtonItem alloc ] initWithCustomView : activityIndicator ] ;
    
    // Feeds ;
    arrForFeed          = [ NSMutableArray array ] ;
    arrForSearch        = [ NSMutableArray array ] ;
    
    self.searchBarController.searchBarView.frame = self.searchBar.frame;
    
    [tblForExplore setFrame:CGRectMake(0, self.searchBar.frame.origin.y + self.searchBar.frame.size.height, 320, self.tabBarController.tabBar.frame.origin.y - 110)];
    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ self.navigationController setNavigationBarHidden : NO animated : YES ] ;
    
    [ self loadFeeds ] ;
    
    [self.searchBar.superview addSubview:self.searchBarController.searchBarView];
    self.searchBarController.delegate= self;
    self.searchBar = self.searchBarController.searchBarView;
    [self.searchBarController.searchView setHidden:NO];
    //UIBarButtonItem *btnRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(actionRefresh:)];
    
//    [btnRefresh set setTintColor:[UIColor colorWithRed:60.0f green:145.0f blue:145.0f alpha:1.0f]];

 //   [self.tabBarController.navigationItem setRightBarButtonItem:btnRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - search method
- (void)filterListForSearchText : (NSString* )searchText{
    
    
}

#pragma mark - loadfeed

- ( void ) loadFeeds
{

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
        
        // Reload ;
        [ tblForExplore reloadData ] ;
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        // Refresh ;
        [ activityIndicator stopAnimating ] ;
        [ self.navigationItem setRightBarButtonItem : itemForRefresh ] ;

    } ;
    
    [ [ SocialCommunication sharedManager ] FeedNews : successed
                                             failure : failure ] ;
}

#pragma mark - Events
- ( IBAction ) onBtnRefresh : ( id ) _sender
{
    [ self loadFeeds ] ;
}


#pragma mark - UITableView Delegate
- ( NSInteger ) numberOfSectionsInTableView : ( UITableView* ) _tableView
{
    return 1 ;
}

- ( NSInteger ) tableView : ( UITableView* ) _tableView numberOfRowsInSection : ( NSInteger ) _section
{
    if (_tableView == self.searchBarController.searchView.searchTable) {
        return [arrForSearch count];
    }else{
        return ( [ arrForFeed count ] / kNumberOfOneCell ) + ( [ arrForFeed count ] % kNumberOfOneCell ? 1 : 0 ) ;
    }
}

- ( CGFloat ) tableView : ( UITableView* ) _tableView heightForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    if (_tableView == self.searchBarController.searchView.searchTable) {
        return 40;
    }else{
//        return 103.0f ;
        return 220.0f ;   // 3K (25/01/2014)
    }
}

- ( UITableViewCell* ) tableView : ( UITableView* ) _tableView cellForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    if (_tableView == self.searchBarController.searchView.searchTable) {
        UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[arrForSearch objectAtIndex:_indexPath.row]];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        return cell;
    }else{
        SocialFeedGrid*     cell    = [ tblForExplore dequeueReusableCellWithIdentifier : @"SocialFeedGrid" ] ;
        
        if( cell == nil )
        {
            cell    = [ SocialFeedGrid sharedCell ] ;
        }
        
        [ cell setDelegate : self ] ;
        [ cell setFeed1 : [ arrForFeed objectAtIndex : _indexPath.row * kNumberOfOneCell + 0 ] ] ;
        [ cell setFeed2 : _indexPath.row * kNumberOfOneCell + 1 < [ arrForFeed count ] ? [ arrForFeed objectAtIndex : _indexPath.row * kNumberOfOneCell + 1 ] : nil ] ;
//        [ cell setFeed3 : _indexPath.row * kNumberOfOneCell + 2 < [ arrForFeed count ] ? [ arrForFeed objectAtIndex : _indexPath.row * kNumberOfOneCell + 2 ] : nil ] ;
        
        return cell ;
    }

}

- ( void ) tableView : ( UITableView* ) _tableView didSelectRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    if (_tableView == self.searchBarController.searchView.searchTable) {
        [self.searchBarController.searchView setHidden:YES];
        SocialTagViewController *viewController = [[SocialTagViewController alloc] initWithTag:[arrForSearch objectAtIndex:_indexPath.row]];
        [self.navigationController pushViewController:viewController animated:YES];
        
    }
}

- ( void ) didSelectedFeed : ( SocialFeed* ) _feed
{
//    SocialFeedController*   viewController  = [ [ SocialFeedController alloc ] initWithFeed : _feed ]  ;
    
    SocialFeedDetailViewController *viewController = [[SocialFeedDetailViewController alloc] initWithFeed:_feed];
    
    // Push ;
    [ self.navigationController pushViewController : viewController animated : YES ] ;
    
}

#pragma mark - searchbarcontroller delegate

-(void)searchBar:(MDSearchBarController *)searchBarController searchWithText:(NSString *)text{
    if ([text isEqualToString:@""]) {
        return;
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
        [ arrForSearch removeAllObjects ] ;
        
        for( NSDictionary* dict in _responseObject )
        {
            // Add ;
            [arrForSearch addObject:[dict objectForKey:@"tag_text"]];
        }
        
        //reload
        [ self.searchBarController.searchView.searchTable reloadData ] ;
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        // Refresh ;
        [ activityIndicator stopAnimating ] ;
        [ self.navigationItem setRightBarButtonItem : itemForRefresh ] ;
    } ;
    
    [[SocialCommunication sharedManager ] SearchTag:text successed:successed failure:failure];
    
}

@end
