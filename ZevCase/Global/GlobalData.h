//
//  GlobalData.h
//  Kitchen Rush
//
//  Created by Yu Li on 7/21/13.
//  Copyright (c) 2012 Yu Li. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommonMethods.h"

typedef enum
{
    FILTER_ORIGINAL     = 0,
    FILTER_BOOKSTORE,
    FILTER_CITY,
    FILTER_COUNTRY,
    FILTER_FILM,
    FILTER_FOREST,
    FILTER_LAKE,
    FILTER_MOMENT,
    FILTER_NYC,
    FILTER_TEA,
    FILTER_VINTAGE,
    FILTER_1Q84,
    FILTER_BW,
} FILTER_TYPE ;

@interface GlobalData : NSObject

@property (nonatomic) NSInteger selectedFilterIndex;
@property (nonatomic) NSInteger selectedOverlayIndex;
@property (nonatomic, retain) NSString *selectedOverlay;

@property (nonatomic, retain) NSArray *arrayPhone;
@property (nonatomic, retain) NSArray *arraySelectedPhone;

+ (id) sharedData;
- (void)loadInitData;

@end


// ###################################################
// ###################################################

#pragma mark - GlobalMethods Class

@interface GlobalMethods : NSObject

+ (void) setRoundView:(UIView*)view borderColor:(UIColor *)color;
+ (void) setRoundView:(UIView *)view cornorRadious:(float)rad borderColor:(UIColor *)color border:(float)border;

@end
