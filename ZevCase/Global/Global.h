//
//  Global.h
//  Kitchen Rush
//
//  Created by Yu Li on 7/21/13.
//  Copyright (c) 2012 Yu Li. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>

#import "GlobalData.h"

#pragma mark - Define MACRO -

#pragma mark - Define Variable -
extern GlobalData *_globalData;

// screen
#define IS_WIDESCREEN   (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPAD         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IS_IPOD         ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

#define IOS_7           ([[[UIDevice currentDevice] systemVersion] isEqualToString:@"7.0"])

#define IS_IPHONE5 ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568) ? YES : NO )

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SAVE_DATA_KEY @"stored_data"
#define SAVE_IMAGE_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define TEMP_IMAGE_PATH [NSTemporaryDirectory() stringByAppendingString:@"/image.png"]