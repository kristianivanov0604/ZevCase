//
//  PhoneSelectViewController.m
//  ZevCase
//
//  Created by Liming Zhang on 10/12/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "PhoneSelectViewController.h"
#import "InitialSlidingViewController.h"
#import "Global.h"


@interface PhoneSelectViewController ()

@end

@implementation PhoneSelectViewController
@synthesize scrollPhone;
@synthesize scrollLayout;

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
    
    arrayPhone = [NSArray arrayWithObjects:@"iphone5",@"iphone5s",@"iphone4", @"ipod-touch-5",@"iphone5c", nil];
    
    [scrollPhone setContentSize:CGSizeMake(400, 100)];
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"devices" ofType:@"plist"];
    arrayDevice = [NSArray arrayWithContentsOfFile:plistPath];
    
    plistPath = [[NSBundle mainBundle] pathForResource:@"layouts" ofType:@"plist"];
    arrayLayout = [NSArray arrayWithContentsOfFile:plistPath];
    
    NSLog(@"%@", arrayLayout);

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

-(IBAction)actionSelected:(id)sender{
    
    for (int i = 10; i < 15; i++) {
        [(UIButton*)[scrollPhone viewWithTag:i] setSelected:NO];
    }
    [(UIButton*)sender setSelected:YES];
    
    [self clearLayout];
    
    if (arraySelected) {
        [arraySelected removeAllObjects];
    }else{
        arraySelected = [NSMutableArray array];
    }
    
    for (int i = 0 ; i < [arrayLayout count]; i++) {
        if ([[arrayPhone objectAtIndex:[sender tag] - 10] isEqualToString:[[arrayLayout objectAtIndex:i] objectForKey:@"Device"]]) {
            NSDictionary *dict = [arrayLayout objectAtIndex:i];
            [arraySelected addObject:dict];
        }
    }
    
    for (int i = 0; i < [arraySelected count]; i++) {
        int row = i / 3;
        int column = i % 3;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(95*column + 30, 120*row + 20, 65, 100)];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [[arraySelected objectAtIndex:i] objectForKey:@"Icon"]]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
        [self.scrollLayout addSubview:button];
    }
    if ([arraySelected count] % 3 == 0) {
        [self.scrollLayout setContentSize:CGSizeMake(320, ([arraySelected count] / 3 ) * 120 + 20)];
    }else{
        [self.scrollLayout setContentSize:CGSizeMake(320, ([arraySelected count] / 3 + 1) * 120 + 20)];
    }
    
//    NSLog(@"%@", arraySelected);
    
}

-(IBAction)actionBack:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - clear layout
- (void)clearLayout{
    for (UIView *view in self.scrollLayout.subviews) {
        if (view.class == [UIButton class]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - layout selected
- (void)btnSelected:(id)sender{
    arrayButtonSelected = [arraySelected objectAtIndex:[sender tag]];
    NSLog(@"arraybuttonselected = %@", arrayButtonSelected);
    
    _globalData.arraySelectedPhone = arrayButtonSelected;
    
    InitialSlidingViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialSlidingViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
