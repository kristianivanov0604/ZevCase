//
//  AccountDetailsViewController.m
//  ZevCase
//
//  Created by Yu Li on 10/7/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "AccountDetailsViewController.h"

@interface AccountDetailsViewController ()

@end

@implementation AccountDetailsViewController
@synthesize tableAccount;

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

#pragma mark - action

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
    NSString *cellIdentifier = @"GridTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return @"Featured Design Packs";
            break;
        }
        case 1:
        {
            return @"Featured Designers";
            break;
        }
        case 2:
        {
            return @"Featured Designers";
            break;
        }
        default:
            return @"Featured Design";
            break;
    }
    return @"Name";
}

@end
