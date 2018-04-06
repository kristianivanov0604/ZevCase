//
//  ProfileViewController.m
//  ZevCase
//
//  Created by Yu Li on 10/2/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "ProfileViewController.h"

#import "SocialProfileCell.h"
#import "SocialFeedCell.h"

#import "SocialOptionController.h"
#import "SocialEditProfile.h"

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

#import "UIImageView+AFNetworking.h"

#import "AppDelegate.h"

#import <Parse/Parse.h>

@interface ProfileViewController ()
{
    NSInteger       viewMode ;
    NSMutableArray* arrForFeed ;
    
    UIBarButtonItem*    itemForRefresh ;
    UIBarButtonItem*    itemForIndicator ;
    UIActivityIndicatorView* activityIndicator ;
}

// Load ;
- ( void ) loadProfile ;
- ( void ) loadFeeds ;

// Events ;
- ( IBAction ) onBtnSetting : ( id ) _sender ;

@end

@implementation ProfileViewController

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
    
    arrForFeed = [NSMutableArray array];
    
    [tblForFeed setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    
    viewMode    = 1 ;
    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tabBarController.navigationItem setTitle:@"PROFILE"];
    
    itemForRefresh      = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onBtnSetting:)];
    [itemForRefresh setTintColor:[UIColor whiteColor]];
    
    [ self.navigationItem setRightBarButtonItem : itemForRefresh ] ;
    
    // Activity Indicator ;
    activityIndicator   = [ [ UIActivityIndicatorView alloc ] initWithActivityIndicatorStyle : UIActivityIndicatorViewStyleGray ]  ;
    itemForIndicator    = [ [ UIBarButtonItem alloc ] initWithCustomView : activityIndicator ] ;
    
    
    [ self loadProfile ] ;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (void)actionSetting : (id)sender{
    
}

#pragma mark - load profile
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

#pragma mark - load feed

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


#pragma mark - action profile setting

- ( IBAction ) onBtnSetting : ( id ) _sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Log Out" otherButtonTitles: nil];
    actionSheet.tag = 1000;
    [actionSheet showInView:self.view];
}

#pragma mark - action
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
        if( [ arrForFeed count ] )
        {
            return 2 ;
        }
        
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
        switch( _indexPath.row )
        {
            case 0 :
                return 280.0f ;
                
            default :
                break ;
        }
        
        return 0 ;
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
        [cell setHideBackButton:YES];
        
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

- (void) didAvatar{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Change Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose From Gallery", nil];
    [actionSheet showInView:self.view];
}
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

#pragma mark - uiactionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1000) {
        if (buttonIndex == 0) {
            [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
            
            [[SocialCommunication sharedManager] setMe:nil];
            
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation setChannels:nil];
            [currentInstallation saveInBackground];
            
        }
        
    }else{
        switch (buttonIndex) {
            case 0:{
                UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
                pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                pickerController.allowsEditing = YES;
                pickerController.delegate = self;
                [self presentViewController:pickerController animated:YES completion:nil];
                break;
            }
            case 1:{
                UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
                pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                pickerController.allowsEditing = YES;
                pickerController.delegate = self;
                [self presentViewController:pickerController animated:YES completion:nil];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - uiimagepicker controller delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
 //   [_btnPhoto setImage:[info objectForKey:UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        [ self.navigationController popViewControllerAnimated : YES ] ;
        [tblForFeed reloadData];
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        
    } ;
    
    NSData* dataForPhoto    = UIImageJPEGRepresentation( [info objectForKey:UIImagePickerControllerEditedImage], 0.5 ) ;
    
    [ [ SocialCommunication sharedManager ] SetProfile : dataForPhoto
                                                  name : self.userProfile.name
                                              username : self.userProfile.username
                                               website : self.userProfile.website
                                                   bio : self.userProfile.bio
                                                 email : self.userProfile.email
                                                 phone : self.userProfile.phone
                                                gender : self.userProfile.sex
                                             successed : successed
                                               failure : failure ] ;
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
