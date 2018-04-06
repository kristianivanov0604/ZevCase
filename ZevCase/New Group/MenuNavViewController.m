//
//  MenuNavViewController.m
//  ZevCase
//
//  Created by Liming Zhang on 10/25/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "MenuNavViewController.h"

@interface MenuNavViewController ()

@end

@implementation MenuNavViewController

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
    
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;

    self.navigationBarHidden = YES;
    
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.slidingViewController setAnchorRightPeekAmount:40.f];
    self.slidingViewController.underLeftWidthLayout = ECVariableRevealWidth;
    [self.slidingViewController anchorTopViewTo:ECRight];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
