//
//  SocialFeedDetailViewController.m
//  ZevCase
//
//  Created by threek on 1/25/14.
//  Copyright (c) 2014 Yu Li. All rights reserved.
//

#import "SocialFeedDetailViewController.h"
#import "SocialFeed.h"
#import "SocialCommunication.h"
#import "SocialComment.h"
#import "SelectDeviceViewController.h"
#import "SocialUserController.h"
#import "SocialCartViewController.h"
#import "SocialCommentController.h"

#import "GlobalData.h"
#import "UIImageView+AFNetworking.h"

@interface SocialFeedDetailViewController ()

@end

@implementation SocialFeedDetailViewController

// Properties ;
@synthesize feed ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- ( id ) initWithFeed : ( SocialFeed* ) _feed
{
    self = [ self initWithNibName : @"SocialFeedDetailViewController" bundle : nil ] ;
    
    if( self )
    {
        [ self setFeed : _feed ] ;
    }
    
    return self ;
}

- (IBAction)addCartAction:(id)sender {
    SocialCartViewController *viewControlloer = [[SocialCartViewController alloc] initWithFeed:self.feed caseType:lblSelectedDevice.text];
    [self.navigationController pushViewController:viewControlloer animated:YES];
}

- (IBAction)selectDeviceAction:(id)sender {
    SelectDeviceViewController *viewController = [[SelectDeviceViewController alloc] init];
    [viewController setPrevVC:self];
    
    [self.navigationController pushViewController:viewController animated:YES];

}

- (IBAction)viewMoreUserAction:(id)sender {
        SocialUserController*       viewController = [ [ SocialUserController alloc ] initWithUser : self.feed ]  ;
        
        // Push ;
        [ self.navigationController pushViewController : viewController animated : YES ] ;
}

- (IBAction)didLikeAction:(id)sender {
    [ feed setLiked : ![ feed liked ] ] ;
    [ feed setLikes : [ feed likes ] + ( [ feed liked ] ? 1 : -1 ) ] ;
    
    //    [ btnForLike setSelected : [ feed liked ] ] ;
    
    [self setLike:feed.liked];
    
    if( [ feed liked ] )
    {
        [ [ SocialCommunication sharedManager ] LikeAdd : [ self feed ]
                                              successed : nil
                                                failure : nil ] ;
    }
    else
    {
        [ [ SocialCommunication sharedManager ] LikeRemove : [ self feed ]
                                                 successed : nil
                                                   failure : nil ] ;
    }
    
}

- (IBAction)didCommentAction:(id)sender {
    SocialCommentController*    viewController = [ [ SocialCommentController alloc ] initWithFeed : feed ]  ;
    
    // Navigation Bar ;
//    navigationBarHidden = YES ;
    
    // Push ;
    [ self.navigationController pushViewController : viewController animated : YES ] ;

}

- (void)setDeviceType:(NSString *)deviceName
{
    [lblSelectedDevice setText:deviceName];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadController];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initMethod];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- ( void ) dealloc
{
    // Release ;
    [ self setFeed : nil ] ;
    
}

- ( void ) loadController
{
    // Navigation Bar ;
    
    NSString *strTitle = [NSString stringWithFormat:@"%@", feed.name];
    UILabel *lblTitle = [[UILabel alloc] init];
    [lblTitle setText:strTitle];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [lblTitle setFont:[UIFont systemFontOfSize:18.0]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    UIView *viewTitle = [[UIView alloc] init];
    [viewTitle addSubview:lblTitle];
    [viewTitle setBackgroundColor:[UIColor clearColor]];
    [viewTitle setFrame:CGRectMake(0, 0, 120, 30)];
    [lblTitle setFrame:CGRectMake(0, 0, 120, 30)];
    [self.navigationItem setTitleView:viewTitle];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
}

- (void) initMethod
{
    [scrviewMain addSubview:viewMain];
    [scrviewMain setClipsToBounds:NO];
    [scrviewMain setContentSize:viewMain.frame.size];
    
    [imgFeed setImageWithURL:[NSURL URLWithString:feed.photo] placeholderImage:[UIImage imageNamed:@"base_iphone5s-1"]];
    [backImageView setImageWithURL:[NSURL URLWithString:feed.photo] placeholderImage:[UIImage imageNamed:@"base_iphone5s-1"]];
    [lblFeedTitle setText:[NSString stringWithFormat:@"%@", feed.name]];
    
    [imgUserAvator setImageWithURL:[NSURL URLWithString:feed.avatar] placeholderImage:[UIImage imageNamed:@"anonymousUser"]];

    [GlobalMethods setRoundView:imgUserAvator borderColor:nil];
    
    [lblUsername setText:feed.username];
    
    if (feed.userBio.length == 0) {
        [txtUserBio setText:@"no Bio"];
    } else {
        [txtUserBio setText:feed.userBio];
    }
    
    [self setLike:feed.liked];
    [self checkingMyCommented];

    
}

- (void) setLike:(BOOL)flag
{
    if (flag) {
        [imgLike setImage:[UIImage imageNamed:@"liked"]];
        [btnLike setTitle:@"Liked" forState:(UIControlStateNormal)];
        [btnLike setTitleColor:[UIColor colorWithRed:0 green:0.5f blue:0.45f alpha:1.0f] forState:UIControlStateNormal];
    } else {
        [imgLike setImage:[UIImage imageNamed:@"like"]];
        [btnLike setTitle:@"Like" forState:(UIControlStateNormal)];
        [btnLike setTitleColor:[UIColor colorWithWhite:0.4f alpha:1.0f] forState:UIControlStateNormal];
    }
    [lblLikes setText:[NSString stringWithFormat:@"(%d)", feed.likes]];
}

- (void) checkingMyCommented
{
    NSString *meUserID = [ [ SocialCommunication sharedManager ] me ].userid;
    for (SocialComment *elem in feed.commentArray) {
        if ([meUserID isEqualToString:elem.userid]) {
            [imgComment setImage:[UIImage imageNamed:@"commented"]];
            [btnComment setTitle:@"Commented" forState:(UIControlStateNormal)];
            [btnComment setTitleColor:[UIColor colorWithRed:0 green:0.5f blue:0.45f alpha:1.0f]
                             forState:UIControlStateNormal];
            return;
        }
    }
    [imgComment setImage:[UIImage imageNamed:@"comment"]];
    [btnComment setTitle:@"Comment" forState:(UIControlStateNormal)];
    [btnComment setTitleColor:[UIColor colorWithWhite:0.4f alpha:1.0f]
                     forState:UIControlStateNormal];
    
}


@end
