
//
//  SCShareConfigurator.m
//  SplitCamera
//
//  Created by Yu Li on 10/2/12.
//  Copyright (c) 2012 Yu Li. All rights reserved.
//

#import "SCShareConfigurator.h"

@implementation SCShareConfigurator

// Application
- (NSString*)appName {
	return @"ZevCases";
}

- (NSString*)appURL {
	return @"http://www.zevcases.com";
}

// Facebook
- (NSString*)facebookAppId {
	return @"711001688919523";
}

- (NSString*)facebookLocalAppId {
	return @"";
}

// Twitter
- (NSNumber*)forcePreIOS5TwitterAccess {
	return [NSNumber numberWithBool:false];
}

- (NSString*)twitterConsumerKey {
	return @"tALs96hfDC2hs22QCBGwtA";
}

- (NSString*)twitterSecret {
	return @"If7Wn4cVkMsaZzTRWYtftDzsrnEGmcnGxdcKfN5eJQ";
}

- (NSString*)twitterCallbackUrl {
	return @"http://www.zevcases.com";
}

- (NSNumber*)twitterUseXAuth {
	return [NSNumber numberWithInt:0];
}

- (NSString*)twitterUsername {
	return @"yuri84210";
}

// UI
- (NSString*)barStyle {
	return @"UIBarStyleBlack";
}

- (UIColor*)barTintForView:(UIViewController*)vc {
	
    if ([NSStringFromClass([vc class]) isEqualToString:@"SHKTwitter"])
        return [UIColor colorWithRed:0 green:151.0f/255 blue:222.0f/255 alpha:1];
    
    if ([NSStringFromClass([vc class]) isEqualToString:@"SHKFacebook"])
        return [UIColor colorWithRed:59.0f/255 green:89.0f/255 blue:152.0f/255 alpha:1];
    
    return nil;
}

@end
