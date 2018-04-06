//
//  OverlayDetailViewController.m
//  ZevCase
//
//  Created by Liming Zhang on 10/26/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "OverlayDetailViewController.h"
#import "MainViewController.h"
#import "Global.h"

@interface OverlayDetailViewController ()

@end

@implementation OverlayDetailViewController
@synthesize type;

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

- (void)viewWillAppear:(BOOL)animated{
    arrayOverlayCount = [[NSArray alloc] initWithObjects:@"48",@"23", @"24", @"19", @"0", @"0", @"0", nil];
    arrayOverlay = [[NSArray alloc] initWithObjects:@"shape",@"line", @"frame", @"texture", @"", @"", @"", nil];
    
    _globalData.selectedOverlay = [arrayOverlay objectAtIndex:type];
    
    switch (type) {
        case 0:{
            [_lblForTitle setText:@"Shape"];
            break;
        }
        case 1:{
            [_lblForTitle setText:@"Line"];
            break;
        }
        case 2:{
            [_lblForTitle setText:@"Frame"];
            break;
        }
        case 3:{
            [_lblForTitle setText:@"Texture"];
            break;
        }
            
        default:
            break;
    }
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

#pragma mark - tableview delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    NSLog(@"%@", [arrayOverlayCount objectAtIndex:type]);
    if (([[arrayOverlayCount objectAtIndex:type] integerValue]) % 2 == 0 ) {
        return ([[arrayOverlayCount objectAtIndex:type] integerValue]) / 2;
    }else{
        return ([[arrayOverlayCount objectAtIndex:type] integerValue]) / 2 + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"OverlayDetailCell";
    OverlayDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[OverlayDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row < 4) {
        [cell._btnLeft setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@0%lu", [arrayOverlay objectAtIndex:type], (unsigned long)indexPath.row * 2 + 1]] forState:UIControlStateNormal];
        [cell._btnRight setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@0%lu", [arrayOverlay objectAtIndex:type], (unsigned long)indexPath.row * 2 + 2]] forState:UIControlStateNormal];
    }else if(indexPath.row == 4){
        [cell._btnLeft setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@0%lu", [arrayOverlay objectAtIndex:type], (unsigned long)indexPath.row * 2 + 1]] forState:UIControlStateNormal];
        [cell._btnRight setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%lu", [arrayOverlay objectAtIndex:type], (unsigned long)indexPath.row * 2 + 2]] forState:UIControlStateNormal];
    }else{
        [cell._btnLeft setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%lu", [arrayOverlay objectAtIndex:type], (unsigned long)indexPath.row * 2 + 1]] forState:UIControlStateNormal];
        [cell._btnRight setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%lu", [arrayOverlay objectAtIndex:type], (unsigned long)indexPath.row * 2 + 2]] forState:UIControlStateNormal];
    }
    
    [cell._btnLeft setTag:indexPath.row * 2 + 101];
    [cell._btnRight setTag:indexPath.row * 2 + 102];
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", (long)indexPath.row);
}

- (void)didSelected:(id)picker{
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        
        [self.slidingViewController resetTopView];
    }];
    NSString* strImage;
    if(_globalData.selectedOverlayIndex < 110){
        strImage = [NSString stringWithFormat:@"img_%@0%d",_globalData.selectedOverlay, _globalData.selectedOverlayIndex-100];
    }else{
        strImage = [NSString stringWithFormat:@"img_%@%d",_globalData.selectedOverlay, _globalData.selectedOverlayIndex-100];
    }
    
    NSLog(@"%@", strImage);
//    [self.slidingViewController.topViewController.view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:strImage]]];
    [(MainViewController*)self.slidingViewController.topViewController addOverlayImage:[UIImage imageNamed:strImage]];
//    [self.slidingViewController resetTopView];
}
@end
