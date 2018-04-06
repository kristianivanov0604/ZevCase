//
//  ViewController.m
//  ZevCase
//
//  Created by Yu Li on 9/29/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "ViewController.h"
#import "Chartboost.h"
#import "DisplayViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults * userinfo = [NSUserDefaults standardUserDefaults];
    username = [userinfo objectForKey:@"username"];
    password = [userinfo objectForKey:@"password"];
    
    if ( username != nil && password != nil)
    {
         [self.navigationController setNavigationBarHidden:YES animated:NO];
        DisplayViewController *displayViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"main"];
        [self.navigationController pushViewController:displayViewController animated:YES];
    }

    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [[Chartboost sharedChartboost] showInterstitial];
//    [self.navigationController.navigationItem setTintColor:[UIColor colorWithRed:100.0 green:145.0 blue:145.0 alpha:0.5]];;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
