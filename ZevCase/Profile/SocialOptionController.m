//
//  SocialOptionController.m
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import "SocialOptionController.h"
#import "SocialOptionCell.h"

// --- Defines --- ;
// SocialOptionController Class ;
@interface SocialOptionController ()
{
    NSArray*    arrForOption ;
}

// Properties ;

// Load ;
- ( void ) loadController ;

// Events ;

@end

@implementation SocialOptionController

// Functions ;
#pragma mark - SocialOptionController
- ( id ) initWithNibName : ( NSString* ) _nibNameOrNil bundle : ( NSBundle* ) _nibBundleOrNil
{
    self = [ super initWithNibName : _nibNameOrNil bundle : _nibBundleOrNil ] ;
    
    if( self )
    {
        NSString* path   = [ [ NSBundle mainBundle ] pathForResource : @"SocialOptions" ofType : @"plist" ] ;
        
        // Options ;
        arrForOption = [ NSArray arrayWithContentsOfFile : path ] ;

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

#pragma mark - UITableView Delegate
- ( NSInteger ) numberOfSectionsInTableView : ( UITableView* ) _tableView
{
    return [ arrForOption count ] ;
}

- ( CGFloat ) tableView : ( UITableView* ) _tableView heightForHeaderInSection : ( NSInteger ) _section
{
    NSDictionary*   dict    = [ arrForOption objectAtIndex : _section ] ;
    NSString*       header  = [ dict objectForKey : @"header" ] ;
    
    if( [ header isEqualToString : @"" ] )
    {
        return 0.0f ;
    }

    return [ SocialOptionHeader height : header ] ;
}

- ( UIView* ) tableView : ( UITableView* ) _tableView viewForHeaderInSection : ( NSInteger ) _section
{
    NSDictionary*   dict    = [ arrForOption objectAtIndex : _section ] ;
    NSString*       header  = [ dict objectForKey : @"header" ] ;
    
    SocialOptionHeader* view    = [ SocialOptionHeader sharedView ] ;
    
    [ view setTitle : header ] ;
    
    return view ;
}

- ( CGFloat ) tableView : ( UITableView* ) _tableView heightForFooterInSection : ( NSInteger ) _section
{
    NSDictionary*   dict    = [ arrForOption objectAtIndex : _section ] ;
    NSString*       footer  = [ dict objectForKey : @"footer" ] ;

    if( [ footer isEqualToString : @"" ] )
    {
        return 0.0f ;
    }

    return [ SocialOptionFooter height : footer ] ;
}

- ( UIView* ) tableView : ( UITableView* ) _tableView viewForFooterInSection : ( NSInteger ) _section
{
    NSDictionary*   dict    = [ arrForOption objectAtIndex : _section ] ;
    NSString*       footer  = [ dict objectForKey : @"footer" ] ;
    
    SocialOptionFooter* view    = [ SocialOptionFooter sharedView ] ;
    
    [ view setTitle : footer ] ;
    
    return view ;
}

- ( NSInteger ) tableView : ( UITableView* ) _tableView numberOfRowsInSection : ( NSInteger ) _section
{
    NSDictionary*   dict    = [ arrForOption objectAtIndex : _section ] ;
    NSArray*        items   = [ dict objectForKey : @"items" ] ;
    
    return [ items count ] ;
}

- ( CGFloat ) tableView : ( UITableView* ) _tableView heightForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    return 44.0f ;
}

- ( UITableViewCell* ) tableView : ( UITableView* ) _tableView cellForRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    NSDictionary*   dict        = [ arrForOption objectAtIndex : _indexPath.section ] ;
    NSArray*        items       = [ dict objectForKey : @"items" ] ;
    NSDictionary*   item        = [ items objectAtIndex : _indexPath.row ] ;

//  NSString*       key         = [ item objectForKey : @"key" ] ;
    NSString*       title       = [ item objectForKey : @"title" ] ;
    NSString*       type        = [ item objectForKey : @"type" ] ;

    UIImage*        normal      = nil ;
    UIImage*        highlight   = nil ;
    
    NSInteger       cellType    = 0 ;
    
    if( [ items count ] == 1 )
    {
        cellType    = 0 ;

        normal      = [ [ UIImage imageNamed : @"cell-single-default.png" ] resizableImageWithCapInsets : UIEdgeInsetsMake( 11, 13, 11, 13 ) ] ;
        highlight   = [ [ UIImage imageNamed : @"cell-single-active.png" ] resizableImageWithCapInsets : UIEdgeInsetsMake( 11, 13, 11, 13 ) ] ;
        
//      normal      = [ [ UIImage imageNamed : @"cell-single-default.png" ] stretchableImageWithLeftCapWidth : 13 topCapHeight : 11 ] ;
//      highlight   = [ [ UIImage imageNamed : @"cell-single-active.png" ] stretchableImageWithLeftCapWidth : 13 topCapHeight : 11 ] ;
    }
    else if( _indexPath.row == 0 )
    {
        cellType    = 1 ;
        
        normal      = [ [ UIImage imageNamed : @"cell-multi-top-default.png" ] resizableImageWithCapInsets : UIEdgeInsetsMake( 10, 13, 12, 13 ) ] ;
        highlight   = [ [ UIImage imageNamed : @"cell-multi-top-active.png" ] resizableImageWithCapInsets : UIEdgeInsetsMake( 10, 13, 12, 13 ) ] ;
        
//      normal      = [ [ UIImage imageNamed : @"cell-multi-top-default.png" ] stretchableImageWithLeftCapWidth : 13 topCapHeight : 11 ] ;
//      highlight   = [ [ UIImage imageNamed : @"cell-multi-top-active.png" ] stretchableImageWithLeftCapWidth : 13 topCapHeight : 11 ] ;
    }
    else if( _indexPath.row == [ items count ] - 1 )
    {
        cellType    = 2 ;
        
        normal      = [ [ UIImage imageNamed : @"cell-multi-bottom-default.png" ] resizableImageWithCapInsets : UIEdgeInsetsMake( 12, 13, 12, 10 ) ] ;
        highlight   = [ [ UIImage imageNamed : @"cell-multi-bottom-active.png" ] resizableImageWithCapInsets: UIEdgeInsetsMake( 12, 13, 12, 10 ) ] ;
        
//      normal      = [ [ UIImage imageNamed : @"cell-multi-bottom-default.png" ] stretchableImageWithLeftCapWidth : 13 topCapHeight : 11 ] ;
//      highlight   = [ [ UIImage imageNamed : @"cell-multi-bottom-active.png" ] stretchableImageWithLeftCapWidth : 13 topCapHeight : 11 ] ;
    }
    else
    {
        cellType    = 3 ;
        
        normal      = [ [ UIImage imageNamed : @"cell-multi-mid-default.png" ] stretchableImageWithLeftCapWidth : 13 topCapHeight : 11 ] ;
        highlight   = [ [ UIImage imageNamed : @"cell-multi-mid-active.png" ] stretchableImageWithLeftCapWidth : 13 topCapHeight : 11 ] ;
    }
    
    if( [ type isEqualToString : @"indicator" ] )
    {
        SocialOptionIndicator*  cell    = [ tblForOption dequeueReusableCellWithIdentifier : @"SocialOptionIndicator" ] ;

        if( cell == nil )
        {
            cell = [ SocialOptionIndicator sharedCell ] ;
        }
        
        [ cell setType : cellType ] ;
        [ cell setTitle : title ] ;
        [ cell setImage : normal  highlight : highlight ] ;
        return cell ;
    }

    if( [ type isEqualToString : @"button" ] )
    {
        SocialOptionButton*     cell    = [ tblForOption dequeueReusableCellWithIdentifier : @"SocialOptionButton" ] ;
        
        if( cell == nil )
        {
            cell = [ SocialOptionButton sharedCell ] ;
        }
        
        [ cell setType : cellType ] ;
        [ cell setTitle : title ] ;
        [ cell setImage : normal  highlight : highlight ] ;
        return cell ;
    }

    if( [ type isEqualToString : @"switch" ] )
    {
        SocialOptionSwitch*     cell    = [ tblForOption dequeueReusableCellWithIdentifier : @"SocialOptionSwitch" ] ;
        
        if( cell == nil )
        {
            cell = [ SocialOptionSwitch sharedCell ] ;
        }
        
        [ cell setType : cellType ] ;
        [ cell setTitle : title ] ;
        [ cell setImage : normal  highlight : highlight ] ;
        return cell ;
    }

    if( [ type isEqualToString : @"checkmark" ] )
    {
        SocialOptionCheckmark*  cell    = [ tblForOption dequeueReusableCellWithIdentifier : @"SocialOptionCheckmark" ] ;
        
        if( cell == nil )
        {
            cell = [ SocialOptionCheckmark sharedCell ] ;
        }
        
        [ cell setType : cellType ] ;
        [ cell setTitle : title ] ;
        [ cell setImage : normal  highlight : highlight ] ;        
        return cell ;
    }
    
    return nil ;
}

- ( void ) tableView : ( UITableView* ) _tableView didSelectRowAtIndexPath : ( NSIndexPath* ) _indexPath
{
    
}

#pragma mark - Load
- ( void ) loadController
{
    // Navigation Bar ;
    [ self.navigationItem setTitle : @"Options" ] ;
    
    // Back Button ;
    UIImage*    imgForBack          = [ [ UIImage imageNamed : @"navbar-button-back.png" ] stretchableImageWithLeftCapWidth : 12 topCapHeight : 0 ] ;
    UIImage*    imgForBackPressed   = [ [ UIImage imageNamed : @"navbar-button-back-active.png" ] stretchableImageWithLeftCapWidth : 12 topCapHeight : 0 ] ;
    
    UIBarButtonItem*    btnForBack      = [ [ UIBarButtonItem alloc ] initWithTitle : @"Profile"
                                                                                style : UIBarButtonItemStyleBordered
                                                                               target : self
                                                                               action : @selector( onBtnProfile: ) ]  ;
    
    [ btnForBack setBackgroundImage : imgForBack forState : UIControlStateNormal barMetrics : UIBarMetricsDefault ] ;
    [ btnForBack setBackgroundImage : imgForBackPressed forState : UIControlStateHighlighted barMetrics : UIBarMetricsDefault ] ;
    [ btnForBack setTitlePositionAdjustment : UIOffsetMake( 2.5f, 0.0f ) forBarMetrics : UIBarMetricsDefault ] ;
    
    [ self.navigationItem setLeftBarButtonItem : btnForBack ] ;

    // Setting Button ;
    UIBarButtonItem*    btnForSupport   = [ [ UIBarButtonItem alloc ] initWithTitle : @"Support"
                                                                              style : UIBarButtonItemStyleBordered
                                                                             target : self
                                                                             action : @selector( onBtnSupport: ) ]  ;
    [ self.navigationItem setRightBarButtonItem : btnForSupport ] ;

    // Background ;
    [ imgForBackground setBackgroundColor : [ UIColor colorWithPatternImage : [ UIImage imageNamed : @"cell-background.png" ] ] ] ;
    
    // Reload ;
    [ tblForOption reloadData ] ;
}

- ( IBAction ) onBtnProfile : ( id ) _sender
{
    [ self.navigationController popViewControllerAnimated : YES ] ;
}

- ( IBAction ) onBtnSupport : ( id ) _sender
{
    
}

@end