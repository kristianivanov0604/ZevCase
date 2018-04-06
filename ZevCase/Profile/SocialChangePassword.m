//
//  SocialChangePassword.m
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import "SocialChangePassword.h"

#import "SocialCommunication.h"
#import "SocialUser.h"
#import "SocialFeed.h"

// --- Defines --- ;
// SocialChangePassword Class ;
@interface SocialChangePassword ()

// Properties ;

// Load ;
- ( void ) loadController ;

// Events ;

@end

@implementation SocialChangePassword

// Functions ;
#pragma mark - SocialChangePassword
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

- ( void ) didReceiveMemoryWarning
{
    [ super didReceiveMemoryWarning ] ;
}

- ( void ) dealloc
{
  
}

#pragma mark - Load
- ( void ) loadController
{
    // Navigation Bar ;
    [ self.navigationItem setTitle : @"Password" ] ;
    
    // Cancel Button ;
    UIBarButtonItem*    btnForCancel    = [ [ UIBarButtonItem alloc ] initWithTitle : @"Cancel"
                                                                                style : UIBarButtonItemStyleBordered
                                                                               target : self
                                                                               action : @selector( onBtnCancel : ) ]  ;
    [btnForCancel setTintColor:[UIColor whiteColor]];
    [ self.navigationItem setLeftBarButtonItem : btnForCancel ] ;

    // Save Button ;
    
    UIBarButtonItem*    btnForSave  = [ [ UIBarButtonItem alloc ] initWithTitle : @"Save"
                                                                            style : UIBarButtonItemStyleBordered
                                                                           target : self
                                                                           action : @selector( onBtnSave : ) ]  ;
    [btnForSave setTintColor:[UIColor whiteColor]];
    
    [ self.navigationItem setRightBarButtonItem : btnForSave ] ;
    
    // Background ;
    [ imgForBackground setBackgroundColor : [ UIColor colorWithPatternImage : [ UIImage imageNamed : @"cell-background.png" ] ] ] ;
    
    // Content ;
    [ viewForScroll setContentSize : [ viewForContent frame ].size ] ;
}

#pragma mark - Events
- ( IBAction ) onBtnSave : ( id ) _sender
{
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        [ self.navigationController popViewControllerAnimated : YES ] ;
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        
    } ;
    
    [ [ SocialCommunication sharedManager ] SetPassword : [ txtForOldPassword text ]
                                            newPassword : [ txtForPassword text ]
                                              successed : successed
                                                failure : failure ] ;
}

- ( IBAction ) onBtnCancel : ( id ) _sender
{
    [ self.navigationController popViewControllerAnimated : YES ] ;
}

@end