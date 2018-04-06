//
//  OverlayMarketViewController.m
//  ZevCase
//
//  Created by Liming Zhang on 10/25/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "OverlayMarketViewController.h"

@interface OverlayMarketViewController ()

@end

@implementation OverlayMarketViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

- (IBAction)actionBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
