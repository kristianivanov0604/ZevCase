//
//  PhoneSelectViewController.h
//  ZevCase
//
//  Created by Liming Zhang on 10/12/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneSelectViewController : UIViewController{
    NSArray *arrayPhone;
    NSArray *arrayDevice;
    NSArray *arrayLayout;
    NSMutableArray *arraySelected;
    NSArray *arrayButtonSelected;
}

@property (nonatomic, assign) IBOutlet UIScrollView *scrollPhone;
@property (nonatomic, assign) IBOutlet UIScrollView *scrollLayout;

-(IBAction)actionSelected:(id)sender;
-(IBAction)actionBack:(id)sender;

@end
