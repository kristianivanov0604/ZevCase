//
//  SigninViewController.m
//  ZevCase
//
//  Created by Yu Li on 9/30/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "SigninViewController.h"
#import "MBProgressHUD.h"
#import "SocialCommunication.h"
#import "SocialUser.h"
#import "TabViewController.h"
#import "DisplayViewController.h"


#import <Parse/Parse.h>
#import "Chartboost.h"

@interface SigninViewController ()

- ( void ) showAlertTips : ( NSString* ) _message ;

// Events ;
- ( IBAction ) onBtnBack : ( id ) _sender ;
- ( IBAction ) onBtnSignIn : ( id ) _sender ;

@end

@implementation SigninViewController
@synthesize scrollView;

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
       
    
    [self.scrollView setContentSize:CGSizeMake(320, self.scrollView.frame.size.height + 1)];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"img_navigationbarback"] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] ];
    [_txtUsername becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- ( IBAction ) onBtnBack : ( id ) _sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- ( IBAction ) onBtnSignIn : ( id ) _sender{
    // Check TextField ;
    
    
    [[Chartboost sharedChartboost] showInterstitial];

    if( [ self checkBlankField ] == NO )
    {
        return ;
    }
    
    // Check Password ;
    if( [ self checkPassword ] == NO )
    {
        return ;
    }
    
    // Email ;
    if( [ _txtUsername isFirstResponder ] )
    {
        [ _txtUsername resignFirstResponder ] ;
    }
    
    // Password ;
    if( [ _txtPassword isFirstResponder ] )
    {
        [ _txtPassword resignFirstResponder ] ;
    }
    
    [ MBProgressHUD showHUDAddedTo : self.view animated : YES ] ;
    
    // Sign In ;
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        // Hide ;
        [ self.navigationItem.rightBarButtonItem setEnabled : YES ] ;
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        if ([_responseObject isEqual:nil]) {
            [ self  showAlertTips : @"Connection Problem" ] ;
            [_txtUsername becomeFirstResponder];
            return ;
        }
        
        // Parse ;
        if( [ [ _responseObject objectForKey : @"result" ] isEqualToString : @"failed" ] )
        {
            [ self  showAlertTips : [ _responseObject objectForKey : @"message" ] ] ;
            [_txtUsername becomeFirstResponder];
            return ;
        }
        
        // Set ;
        NSDictionary*   dict    = [ _responseObject objectForKey : @"user" ] ;
        SocialUser*     user    = [ [ SocialUser alloc ] initWithDict : dict ]  ;
        NSUserDefaults * userInfos = [NSUserDefaults standardUserDefaults];
        [userInfos setObject:_txtUsername.text  forKey:@"username"];
        [userInfos setObject:_txtPassword.text forKey:@"password"];
        [ [ SocialCommunication sharedManager ] setMe : user ] ;
        
        NSString *strChannel = [NSString stringWithFormat:@"user_%@", [user userid]];
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setChannels:[[NSArray alloc] initWithObjects:strChannel, nil]];
        [currentInstallation saveInBackground];
        // Dismiss ;
        TabViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        // Hide ;
        [ self.navigationItem.rightBarButtonItem setEnabled : YES ] ;
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        // Error ;
        [ self  showAlertTips : @"Internet Connection Error!" ] ;
    } ;
    
    [ [ SocialCommunication sharedManager ] SignIn : _txtUsername.text
                                          password : _txtPassword.text
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

#pragma mark - Check
- ( BOOL ) checkBlankField
{
    NSArray*        arrayField  = [ NSArray arrayWithObjects : _txtUsername, _txtPassword, nil ] ;
    NSArray*        arrayTitle  = [ NSArray arrayWithObjects : @"Username", @"Password", nil ] ;
    
    UITextField*    textField   = nil ;
    NSString*       textTitle   = nil ;
    
    NSInteger       nInx        = 0 ;
    NSInteger       nCnt        = 0 ;
    
    for( nInx = 0, nCnt = [ arrayField count ] ; nInx < nCnt ; nInx ++ )
    {
        textField   = [ arrayField objectAtIndex : nInx ] ;
        textTitle   = [ arrayTitle objectAtIndex : nInx ] ;
        
        if( [ textField.text isEqualToString : @"" ] )
        {
            [ self showAlertTips : [ NSString stringWithFormat : @"%@ can't be blank. Please try again.", textTitle ] ] ;
            [textField becomeFirstResponder];
            return NO ;
        }
    }
    
    return YES ;
}

- ( BOOL ) checkPassword
{
    return YES ;
}


#pragma mark - TextField Delegate
- ( BOOL ) textFieldShouldReturn : ( UITextField* ) _textField
{
    if( _textField == _txtUsername )
    {
        [ _txtPassword becomeFirstResponder ] ;
    }
    
    if( _textField == _txtPassword )
    {
        [ _txtPassword resignFirstResponder ] ;
        [ self onBtnSignIn : _textField ] ;
    }
    
    return YES ;
}

@end
