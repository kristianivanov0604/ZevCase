//
//  SelectDeviceViewController.m
//  ZevCase
//
//  Created by threek on 1/25/14.
//  Copyright (c) 2014 Yu Li. All rights reserved.
//

#import "SelectDeviceViewController.h"

@interface SelectDeviceViewController ()
{
    NSArray *deviceList, *imageList;
}

@end

@implementation SelectDeviceViewController

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
    
    [self loadController];
    
    deviceList = @[@"iPhone 4/4s",
                   @"iPhone 5/5s",
                   @"iPhone 5c",
                   ];
    
    imageList = @[@"icon_iphone4g",
                  @"icon_iphone5sg",
                  @"icon_iphone5cg",
                  ];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- ( void ) loadController
{
    // Navigation Bar ;
    
    NSString *strTitle = [NSString stringWithFormat:@"Select Device"];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[SelectDeviceCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.textLabel setText:deviceList[indexPath.row]];
        [cell.imageView setImage:[UIImage imageNamed:imageList[indexPath.row]]];
        [cell setBackgroundColor:[UIColor clearColor]];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SEL setDeviceType = @selector(setDeviceType:);
    if (self.prevVC) {
        if ([self.prevVC respondsToSelector:setDeviceType]) {
            [self.prevVC performSelector:setDeviceType withObject:cell.textLabel.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return deviceList.count;
}

@end


@implementation SelectDeviceCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.imageView.frame;
    [self.imageView setFrame:CGRectInset(rect, 2.0f, 5.0f)];
    
}

@end