//
//  ActionViewController.m
//  ZevCase
//
//  Created by Yu Li on 10/2/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "ActionViewController.h"

#import "SocialNotification.h"
#import "SocialNotificationCell.h"
#import "SocialCommunication.h"

#import "SocialUserController.h"

@interface ActionViewController (){
    NSMutableArray *arrForNotification;
}

@end

@implementation ActionViewController
@synthesize tableForNotification;



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
    
    arrForNotification = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived:) name:@"pushNotification" object:nil];
	// Do any additional setup after loading the view.
}

#pragma mark - push notification received

- (void)pushNotificationReceived : (NSNotification*)aNotification{
    [self.tabBarController setSelectedIndex:2];
    [self loadNotification];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBarController.navigationItem setTitle:@"ACTIONS"];
    [self.tabBarController.navigationItem setRightBarButtonItem:nil];
    
    [self loadNotification];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Delegate
- ( NSInteger ) tableView : ( UITableView* ) _tableView numberOfRowsInSection : ( NSInteger ) _section
{
    return [ arrForNotification count ] ;
}

- ( CGFloat ) tableView : ( UITableView* ) _tableView heightForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    return 44.0f ;
}

- ( UITableViewCell* ) tableView : ( UITableView* ) _tableView cellForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    SocialNotificationCell*     cell    = [ tableForNotification dequeueReusableCellWithIdentifier : @"SocialNotificationCell" ] ;
    
    if( cell == nil )
    {
        cell = [ SocialNotificationCell sharedCell ] ;
    }
    [ cell setDelegate : self ] ;
    // Like ;
    [ cell setNotifications : [ arrForNotification objectAtIndex : _indexPath.row ] ] ;
    
    return cell ;
}

- ( void ) tableView : ( UITableView* ) _tableView didSelectRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    
}

#pragma mark - load notification

- (void)loadNotification{
    
    if( [ [ SocialCommunication sharedManager ] me ] == nil )
    {
        return ;
    }
    
    // Like ;
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        // Refresh ;
        [ self.navigationItem setRightBarButtonItem : nil ] ;
        
        // Feeds ;
        [ arrForNotification removeAllObjects ] ;
        
        for( NSDictionary* dict in _responseObject )
        {
            SocialNotification* like    = [ [ SocialNotification alloc ] initWithDict : dict ]  ;
            
            // Add ;
            [ arrForNotification addObject : like ] ;
        }
        
        // Reload ;
        [ tableForNotification reloadData ] ;
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        // Refresh ;
        [ self.navigationItem setRightBarButtonItem : nil ] ;
        
        // Likes ;
        [ arrForNotification removeAllObjects ] ;
        
        // Reload ;
        [ tableForNotification reloadData ] ;
    } ;
    
    [ [ SocialCommunication sharedManager ] Notifications:[[SocialCommunication sharedManager] me]
                                               successed : successed
                                                 failure : failure ] ;
    
    
}

#pragma mark - selected user delegate

- ( void ) didSelectedUser : ( SocialUser* ) _user{
    SocialUserController*       viewController = [ [ SocialUserController alloc ] initWithUser : _user ]  ;
    
    // Push ;
    [ self.navigationController pushViewController : viewController animated : YES ] ;
}

@end
