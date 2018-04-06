//
//  GlobalData.m
//  Kitchen Rush
//
//  Created by Yu Li on 7/21/13.
//  Copyright (c) 2012 Yu Li. All rights reserved.
//

#import "GlobalData.h"
#import "Global.h"

GlobalData *_globalData = nil;

@implementation GlobalData
@synthesize arrayPhone;
@synthesize arraySelectedPhone;
@synthesize selectedOverlay;
@synthesize selectedOverlayIndex;
@synthesize selectedFilterIndex;

+(id) sharedData
{
	@synchronized(self)
    {
        if (_globalData == nil)
        {
            _globalData = [[self alloc] init]; // assignment not done here
        }		
	}
	
	return _globalData;
}
//==================================================================================

+(id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (_globalData == nil)
        {
			_globalData = [super allocWithZone:zone];
			
			return _globalData;
        }
    }
	
    return nil; //on subsequent allocation attempts return nil
}

//==================================================================================

-(id) init
{
	if ((self = [super init])) {
		// @todo
	}
	
	return self;
}

//==================================================================================

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(void) loadInitData
{
    arraySelectedPhone = [[NSArray alloc] init];
    arrayPhone = [[NSArray alloc] init];
    selectedOverlayIndex = -1;
    selectedFilterIndex = 0;
    selectedOverlay = @"";
}

@end


// ###################################################
// ###################################################

#pragma mark - GlobalMethods class

@implementation GlobalMethods

+ (void) setRoundView:(UIView *)view borderColor:(UIColor *)color
{
    float borderWidth = 2.0f;
    if (color == Nil) {
        borderWidth = 0;
    }
    view.layer.cornerRadius = roundf(view.frame.size.height/2.0f);
    view.layer.masksToBounds = YES;
    
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, (view.frame.size.width), (view.frame.size.height));
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setCornerRadius:view.frame.size.width / 2];
    [borderLayer setBorderWidth:borderWidth];
    [borderLayer setBorderColor:color.CGColor];
    [view.layer addSublayer:borderLayer];
}

+ (void) setRoundView:(UIView *)view cornorRadious:(float)rad borderColor:(UIColor *)color border:(float)border
{
    
    view.layer.cornerRadius = rad;
    view.layer.masksToBounds = YES;
    
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, (view.frame.size.width), (view.frame.size.height));
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setCornerRadius:rad];
    [borderLayer setBorderWidth:border];
    [borderLayer setBorderColor:color.CGColor];
    
    [view.layer addSublayer:borderLayer];
    
}

@end