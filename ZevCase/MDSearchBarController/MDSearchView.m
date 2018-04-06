//
//  MDSearchView.m
//  SearchBarProject
//
//  Created by Yu Li on 11/21/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "MDSearchView.h"

@implementation MDSearchView


+(MDSearchView *)view{
    return ( MDSearchView *)[[UIViewController alloc] initWithNibName:@"MDSearchView" bundle:nil].view;
}


-(void)setSearchController:(MDSearchBarController *)searchController{
    _searchController  = searchController;
    self.searchTable.delegate = searchController;
    self.searchTable.dataSource = searchController;
}
- (IBAction)cancel:(id)sender {
    self.searchController.active = NO;
    self.searchController.searchBarView.textField.text = @"";
}
@end
