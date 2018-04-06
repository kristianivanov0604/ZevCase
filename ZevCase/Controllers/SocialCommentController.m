//
//  SocialCommentController.m
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import "SocialCommentController.h"
#import "SocialCommentCell.h"

#import "SocialCommunication.h"
#import "SocialFeed.h"
#import "SocialComment.h"

// --- Defines --- ;
// SocialCommentController Class ;
@interface SocialCommentController ()
{
    NSMutableArray*     arrForComment ;
}

// Load ;
- ( void ) loadController ;
- ( void ) loadComments ;

@end

@implementation SocialCommentController

// Properties ;
@synthesize feed ;

// Functions ;
#pragma mark - SocialCommentController
- ( id ) initWithFeed : ( SocialFeed* ) _feed
{
    self = [ self initWithNibName : @"SocialCommentController" bundle : nil ] ;
    
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
    [ self loadComments ] ;
}

- (void) viewWillAppear:(BOOL)animated{
    [self loadComments];
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
    // Release ;

     
}

#pragma mark - Table Delegate
- ( NSInteger ) tableView : ( UITableView* ) _tableView numberOfRowsInSection : ( NSInteger ) _section
{
    return [ arrForComment count ] ;
}

- ( CGFloat ) tableView : ( UITableView* ) _tableView heightForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    return 54.0f ;
}

- ( UITableViewCell* ) tableView : ( UITableView* ) _tableView cellForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    SocialCommentCell*  cell    = [ tblForComment dequeueReusableCellWithIdentifier : @"SocialCommentCell" ] ;
    
    if( cell == nil )
    {
        cell = [ SocialCommentCell sharedCell ] ;
    }
    
    // Like ;
    [ cell setDelegate : self ] ;
    [ cell setComment : [ arrForComment objectAtIndex : _indexPath.row ] ] ;
    
    return cell ;
}

- ( void ) tableView : ( UITableView* ) _tableView didSelectRowAtIndexPath : ( NSIndexPath* ) _indexPath
{

}

#pragma makr - ScrollView Delegate
- ( void ) scrollViewWillEndDragging : ( UIScrollView* ) _scrollView withVelocity : ( CGPoint ) _velocity targetContentOffset : ( inout CGPoint* ) _targetContentOffset
{
    if( [ txtForComment isFirstResponder ] )
    {
        if( _velocity.y < - 0.2f )
        {
            [ self closeKeyBoard ] ;
        }
    }
}

#pragma mark - TextField Delegate
- ( void ) textFieldDidBeginEditing : ( UITextField* ) _textField
{
    [ self openKeyBoard ] ;
}

- ( void ) textFieldDidEndEditing : ( UITextField* ) _textField
{
    [ btnForComment setEnabled : [ [ txtForComment text ] isEqualToString : @"" ] ] ;
}

- ( BOOL ) textFieldShouldReturn : ( UITextField* ) _textField
{
    [ self onBtnSend : _textField ] ;
    return YES ;
}

#pragma mark - Actions
- ( void ) didTouchesBegan : ( SocialComment* ) _comment
{
    [ tblForComment setScrollEnabled : NO ] ;
}

- ( void ) didTouchesEnded : ( SocialComment* ) _comment
{
    [ tblForComment setScrollEnabled : YES ] ;
}

#pragma mark - Load
- ( void ) loadController
{
    // Navigation Bar ;
    
    NSString *strTitle = @"Comments";
    UILabel *lblTitle = [[UILabel alloc] init];
    [lblTitle setText:strTitle];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [lblTitle setFont:[UIFont systemFontOfSize:18.0]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    UIView *viewTitle = [[UIView alloc] init];
    [viewTitle addSubview:lblTitle];
    [viewTitle setBackgroundColor:[UIColor clearColor]];
    [viewTitle setFrame:CGRectMake(0, 0, 100, 30)];
    [lblTitle setFrame:CGRectMake(0, 0, 100, 30)];
    [self.navigationItem setTitleView:viewTitle];

    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // Navigation Bar ;
    UIImage*    imgForBackground        = [ [ UIImage imageNamed : @"comment-new-bg.png" ] resizableImageWithCapInsets : UIEdgeInsetsMake( 22.0f, 0.5f, 22.0f, 0.5f ) ] ;
    [ naviForComment setBackgroundImage : imgForBackground forBarMetrics : UIBarMetricsDefault ] ;
    
    // Text Field ;
    UIImage*    imgForInput             = [ [ UIImage imageNamed : @"comment-new-input-bg.png" ] resizableImageWithCapInsets : UIEdgeInsetsMake( 15.0f, 3.0f, 15.0f, 4.0f ) ] ;
    [ txtForComment setBackground : imgForInput ] ;

    // Button ;
    UIImage*    imgForButton            = [ [ UIImage imageNamed : @"navbar-button-green.png" ] stretchableImageWithLeftCapWidth : 3.5f topCapHeight : 0 ] ;
    UIImage*    imgForButtonPressed     = [ [ UIImage imageNamed : @"navbar-button-green-active.png" ] stretchableImageWithLeftCapWidth : 3.5f topCapHeight : 0 ] ;
    UIImage*    imgForButtonDisabled    = [ [ UIImage imageNamed : @"navbar-button-green-disabled.png" ] stretchableImageWithLeftCapWidth : 3.5f topCapHeight : 0 ] ;
    
    [ btnForComment setBackgroundImage : imgForButton forState : UIControlStateNormal barMetrics : UIBarMetricsDefault ] ;
    [ btnForComment setBackgroundImage : imgForButtonPressed forState : UIControlStateHighlighted barMetrics : UIBarMetricsDefault ] ;
    [ btnForComment setBackgroundImage : imgForButtonDisabled forState : UIControlStateDisabled barMetrics : UIBarMetricsDefault ] ;

    [btnForComment setAction:@selector(onBtnSend:)];
    // Array ;
    arrForComment   = [ [ NSMutableArray alloc ] init ] ;
    
    
}

- ( void ) loadComments
{
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        // Remove All Objects ;
        [ arrForComment removeAllObjects ] ;
        
        // Add ;
        for( NSDictionary* dict in _responseObject )
        {
            SocialComment*  comment = [ [ SocialComment alloc ] initWithDict : dict ]  ;
            
            // Add ;
            [ arrForComment addObject : comment ] ;
        }
        
        // Reload ;
        [ tblForComment reloadData ] ;
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        
    } ;
    
    [ [ SocialCommunication sharedManager ] Comments : [ self feed ]
                                           successed : successed
                                             failure : failure ] ;
}

#pragma mark - KeyBoard
- ( void ) openKeyBoard
{
    CGRect  frame = [ naviForComment frame ] ;
    frame.origin.y -= 216 ;
    
    CGRect  tableFrame  = [ tblForComment frame ] ;
    tableFrame.size.height -= 216 ;
    
    // Animation ;
    [ UIView beginAnimations : nil context : nil ] ;
    [ UIView setAnimationDuration : 0.3 ] ;
    
    [ tblForComment setFrame : tableFrame ] ;
    
    [ naviForComment setFrame : frame ] ;
    [ txtForComment becomeFirstResponder ] ;
    
    [ UIView commitAnimations ] ;
}

- ( void ) closeKeyBoard
{
    CGRect  frame = [ naviForComment frame ] ;
    frame.origin.y += 216 ;
    
    CGRect  tableFrame  = [ tblForComment frame ] ;
    tableFrame.size.height += 216 ;
    
    // Animation ;
    [ UIView beginAnimations : nil context : nil ] ;
    [ UIView setAnimationDuration : 0.3 ] ;
    
    [ tblForComment setFrame : tableFrame ] ;
    
    [ naviForComment setFrame : frame ] ;
    [ txtForComment resignFirstResponder ] ;
    
    [ UIView commitAnimations ] ;
}

- ( IBAction ) onBtnSend : ( id ) _sender
{
    if( [ [ txtForComment text ] isEqualToString : @"" ] )
    {
        return ;
    }
    
    SocialComment*  comment = [ [ SocialComment alloc ] init ]   ;
    SocialUser*     user    = [ [ SocialCommunication sharedManager ] me ] ;

    [ comment setUserid : [ user userid ] ] ;
    [ comment setUsername : [ user username ] ] ;
    [ comment setAvatar : [ user avatar ] ] ;
    [ comment setComment : [ txtForComment text ] ] ;
    [ comment setSending : YES ] ;
    
    // Add ;
    [ arrForComment addObject : comment ] ;

    // Reload ;
    [ tblForComment reloadData ] ;
    
    CGFloat height = tblForComment.contentSize.height - tblForComment.frame.size.height ;
    [ tblForComment setContentOffset : CGPointMake( 0, height > 0 ? height : 0 ) animated : YES ] ;
    
    [ txtForComment setText : @"" ] ;
    
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        [ comment setCommentid : [ _responseObject objectForKey : @"commentid" ] ] ;
        [ comment setSending : NO ] ;
        
        // Reload ;
        [ tblForComment reloadData ] ;
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        
    } ;
    
    [ [ SocialCommunication sharedManager ] CommentAdd : [ self feed ]
                                               comment : [ comment comment ]
                                             successed : successed
                                               failure : failure ] ;
}

@end