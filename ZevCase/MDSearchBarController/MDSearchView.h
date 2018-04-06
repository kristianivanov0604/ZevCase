//
//  MDSearchView.h
//  SearchBarProject
//
//  Created by Yu Li on 11/21/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDSearchBarController.h"

@class MDSearchBarController;

@interface MDSearchView : UIView
@property (nonatomic, strong) IBOutlet UITableView * searchTable;
@property (nonatomic, strong) MDSearchBarController * searchController;


+(MDSearchView *)view;
@end
