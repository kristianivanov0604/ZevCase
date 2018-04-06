//
//  AppDelegate.h
//  ZevCase
//
//  Created by Yu Li on 9/29/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chartboost.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate,RevMobAdsDelegate,ChartboostDelegate>

+ ( AppDelegate* ) sharedDelegate ;

@property (strong, nonatomic) UIWindow *window;

@end
