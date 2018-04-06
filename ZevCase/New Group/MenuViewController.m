//
//  MenuViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "MenuViewController.h"
#import "OverlayViewController.h"

@interface MenuViewController()
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation MenuViewController
@synthesize menuItems;
@synthesize _tableAddLayers;
@synthesize _tableStatic;

- (void)awakeFromNib
{
  self.menuItems = [NSArray arrayWithObjects:@"MainViewController",  nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (tableView == _tableStatic) {
        return 3;
    }else{
        return self.menuItems.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (tableView == _tableStatic) {
        switch (indexPath.row) {
            case 0:{
                NSString *cellIdentifier = @"MenuOverlayMarket";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                break;
            }
            case 1:{
                NSString *cellIdentifier = @"MenuBookMark";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                break;
            }
            case 2:{
                NSString *cellIdentifier = @"MenuAddOverlay";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                break;

            }
            default:
                break;
        }
    }else{
        
        NSString *cellIdentifier = @"MenuItemCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableStatic) {
        switch (indexPath.row) {
            case 0:{
                break;
            }
            case 1:{
                break;
            }
            case 2:{
//                OverlayViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OverlayViewController"];
//
//                [self.navigationController pushViewController:viewController animated:YES];
                
                break;
            }
            default:
                break;
        }
        
    }
}

@end
