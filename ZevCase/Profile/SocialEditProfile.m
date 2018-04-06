//
//  SocialEditProfile.m
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import "SocialEditProfile.h"
#import "SocialChangePassword.h"

#import "SocialCommunication.h"
#import "SocialUser.h"
#import "SocialUserProfile.h"
#import "SocialFeed.h"

#import "SocialSwitchControl.h"

// --- Defines --- ;
// SocialEditProfile Class ;
@interface SocialEditProfile ()

// Properties ;

// Load ;
- ( void ) loadController ;

// Events ;

@end

@implementation SocialEditProfile

// Properties ;
@synthesize userProfile ;

// Functions ;
#pragma mark - SocialEditProfile
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
    
    // Notification ;
    NSNotificationCenter*   notificationCenter  = [ NSNotificationCenter defaultCenter ] ;
    
    [ notificationCenter addObserver : self selector : @selector( didShowKeyBoard: ) name : UIKeyboardDidShowNotification object : nil ] ;
    [ notificationCenter addObserver : self selector : @selector( willHideKeyBoard: ) name : UIKeyboardWillHideNotification object : nil ] ;
}

- ( BOOL ) hidesBottomBarWhenPushed
{
    return YES ;
}

- ( void ) didReceiveMemoryWarning
{
    [ super didReceiveMemoryWarning ] ;
}

- ( void ) dealloc
{
    [ [ NSNotificationCenter defaultCenter ] removeObserver : self ] ;
   
}

#pragma mark - UITextField Delegate
#pragma mark - TextField Delegate
- ( BOOL ) textFieldShouldReturn : ( UITextField* ) _textField
{
    if( _textField == txtForName )
    {
        [ txtForUsername becomeFirstResponder ] ;
    }
    else if( _textField == txtForUsername )
    {
        [ txtForWebsite becomeFirstResponder ] ;
    }
    else if( _textField == txtForWebsite )
    {
        [ txtForBio becomeFirstResponder ] ;
    }
    else if( _textField == txtForBio )
    {
        [ txtForBio resignFirstResponder ] ;
    }
    else if( _textField == txtForEmail )
    {
        [ txtForPhone becomeFirstResponder ] ;
    }
    else if( _textField == txtForPhone )
    {
        [ txtForPhone resignFirstResponder ] ;
    }
    
    return YES ;
}

#pragma mark - Notification ;
- ( void ) didShowKeyBoard : ( NSNotification* ) _notification
{
    CGRect rectForScroll    = [ viewForScroll frame ] ;
    CGRect rectForKeyBoard  = [ [ _notification.userInfo valueForKey : UIKeyboardFrameEndUserInfoKey ] CGRectValue ] ;
    
    [ viewForScroll setFrame : CGRectMake( rectForScroll.origin.x, rectForScroll.origin.y, rectForScroll.size.width, rectForScroll.size.height - rectForKeyBoard.size.height ) ] ;
}

- ( void ) willHideKeyBoard : ( NSNotification* ) _notification
{
    CGRect rectForScroll    = [ viewForScroll frame ] ;
    CGRect rectForKeyBoard  = [ [ _notification.userInfo valueForKey : UIKeyboardFrameEndUserInfoKey ] CGRectValue ] ;
    
    [ viewForScroll setFrame : CGRectMake( rectForScroll.origin.x, rectForScroll.origin.y, rectForScroll.size.width, rectForScroll.size.height + rectForKeyBoard.size.height ) ] ;
}

#pragma mark - Load
- ( void ) loadController
{
    // Navigation Bar ;
    UILabel *labelForTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [labelForTitle setText:@"Edit Profile"];
    [labelForTitle setTextColor:[UIColor whiteColor]];
    [labelForTitle setFont:[UIFont systemFontOfSize:18.0]];
    [labelForTitle setTextAlignment:NSTextAlignmentCenter];
    
    [self.navigationItem setTitleView:labelForTitle];
    
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
    
    // Change Password ;
    UIImage*    imgForSigle         = [ [ UIImage imageNamed : @"cell-single-active.png" ] stretchableImageWithLeftCapWidth : 13.0f topCapHeight : 11.0f ] ;
    [ btnForChangePassword setBackgroundImage : imgForSigle forState : UIControlStateHighlighted ] ;
    
    // User Profile ;
    [ txtForName setText : [ [ self userProfile ] name ] ] ;
    [ txtForUsername setText : [ [ self userProfile ] username ] ] ;
    [ txtForWebsite setText : [ [ self userProfile ] website ] ] ;
    [ txtForBio setText : [ [ self userProfile ] bio ] ] ;
    [ txtForEmail setText : [ [ self userProfile ] email ] ] ;
    [ txtForPhone setText : [ [ self userProfile ] phone ] ] ;
    [ txtForGender setText : [ [ self userProfile ] sex ] ] ;
    [ switchForPhotoPrivate setOn : [ [ self userProfile ] photoPrivate ] animated : NO ] ;
}

#pragma mark - Events
- ( IBAction ) onBtnSave : ( id ) _sender
{
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        [ self.navigationController popViewControllerAnimated : YES ] ;
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        
    } ;
    
    [ [ SocialCommunication sharedManager ] SetProfile : nil
                                                  name : [ txtForName text ]
                                              username : [ txtForUsername text ]
                                               website : [ txtForWebsite text ]
                                                   bio : [ txtForBio text ]
                                                 email : [ txtForEmail text ]
                                                 phone : [ txtForPhone text ]
                                                gender : [ txtForGender text ]
                                             successed : successed
                                               failure : failure ] ;
}

- ( IBAction ) onBtnCancel : ( id ) _sender
{
    [ self.navigationController popViewControllerAnimated : YES ] ;
}

- ( IBAction ) onBtnChangePassword : ( id ) _sender
{
    SocialChangePassword*   viewController  = [ [ SocialChangePassword alloc ] initWithNibName : @"SocialChangePassword" bundle : nil ]  ;
    
    // Push ;
    [ self.navigationController pushViewController : viewController animated : YES ] ;
}

@end