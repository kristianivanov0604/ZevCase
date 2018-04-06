//
//  OverlayViewController.m
//  ZevCase
//
//  Created by Liming Zhang on 10/22/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "OverlayViewController.h"
#import "OverlayItemCell.h"
#import "OverlayDetailViewController.h"
#import "Global.h"

@interface OverlayViewController ()

@end

@implementation OverlayViewController

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
    
//    arrayItems  = [NSArray arrayWithObjects:@"Shape",@"Lines", @"Frames", @"Textures", @"Crops", @"Text", @"TextCrops", nil];
    arrayItems  = [NSArray arrayWithObjects:@"Shape",@"Lines", @"Frames", @"Textures", nil];
    
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
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

#pragma mark - tableview delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"OverlayItemCell";
    OverlayItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[OverlayItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell._lblOverlay.text = [arrayItems objectAtIndex:indexPath.row];
    cell._imgIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@", [arrayItems objectAtIndex:indexPath.row]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", [arrayItems objectAtIndex:indexPath.row]);
    
    OverlayDetailViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OverlayDetailViewController"];
    
    viewController.type = indexPath.row;
    
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
