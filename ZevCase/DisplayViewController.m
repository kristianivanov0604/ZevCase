//
//  DisplayViewController.m
//  ZevCase
//
//  Created by ellisa on 2/1/14.
//  Copyright (c) 2014 Yu Li. All rights reserved.
//

#import "DisplayViewController.h"
#import "SocialCommunication.h"
#import "MBProgressHUD.h"
#import "SocialUser.h"
#import "TabViewController.h"
#import <Parse/Parse.h>

@interface DisplayViewController ()

@end

@implementation DisplayViewController

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
    NSUserDefaults * userInfo = [NSUserDefaults standardUserDefaults];
    NSString * username = [userInfo objectForKey:@"username"];
    NSString * password = [userInfo objectForKey:@"password"];
    
    [ MBProgressHUD showHUDAddedTo : self.view animated : YES ] ;
    
    // Sign In ;
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        // Hide ;
        [ self.navigationItem.rightBarButtonItem setEnabled : YES ] ;
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        if ([_responseObject isEqual:nil]) {
            [ self  showAlertTips : @"Connection Problem" ] ;
            return ;
        }
        
        // Parse ;
        if( [ [ _responseObject objectForKey : @"result" ] isEqualToString : @"failed" ] )
        {
            [ self  showAlertTips : [ _responseObject objectForKey : @"message" ] ] ;
            return ;
        }
        
        // Set ;
        NSDictionary*   dict    = [ _responseObject objectForKey : @"user" ] ;
        SocialUser*     user    = [ [ SocialUser alloc ] initWithDict : dict ]  ;
        
        [ [ SocialCommunication sharedManager ] setMe : user ] ;
        
        NSString *strChannel = [NSString stringWithFormat:@"user_%@", [user userid]];
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setChannels:[[NSArray alloc] initWithObjects:strChannel, nil]];
        [currentInstallation saveInBackground];
        // Dismiss ;
        TabViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabViewController"];

//        TabViewController * viewController = [[TabViewController alloc]init];
        
        
        
        [self.navigationController pushViewController:viewController animated:YES];
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        // Hide ;
        [ self.navigationItem.rightBarButtonItem setEnabled : YES ] ;
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        // Error ;
        [ self  showAlertTips : @"Internet Connection Error!" ] ;
    } ;
    
    [ [ SocialCommunication sharedManager ] SignIn : username
                                          password : password
                                         successed : successed
                                           failure :  failure ] ;
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
