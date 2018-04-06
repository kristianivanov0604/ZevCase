//
//  AppDelegate.m
//  ZevCase
//
//  Created by Yu Li on 9/29/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "AppDelegate.h"
#import "Global.h"
#import "SCShareConfigurator.h"

#import "SHKDropbox.h"
#import "SHKGooglePlus.h"
#import "SHKFacebook.h"
#import "EvernoteSDK.h"
//#import "SHKBuffer.h"
#import "PocketAPI.h"

#import "SHKConfiguration.h"
#import "ShareKitDemoConfigurator.h"
#import "SHK.h"

#import <Parse/Parse.h>



#define RevmobID  @"52eca638da01addf65000140"
#define ChartboostID  @"52aa07b42d42da6ea48412ec"
#define ChartboostSignature @"798358a91887211e2e9ec0ccfd238cb987daa464"


@implementation AppDelegate

+ ( AppDelegate* ) sharedDelegate
{
    return ( AppDelegate* )[ [ UIApplication sharedApplication ] delegate ] ;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Revmob  initializing
    
    [RevMobAds startSessionWithAppID:RevmobID];
    
    //
    
    
    
    
    
    [[GlobalData sharedData] loadInitData];
    
    DefaultSHKConfigurator *configurator = [[SCShareConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];

    
    [Parse setApplicationId:@"eqPxkkAAt7e3L5aIwpDMiiV1FeYcb1TTSkPzscTT"
                  clientKey:@"StllI2RRJpxtqCzs8FtUoqC3lxUnTFDGPWDHuf1x"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    [SHKFacebook handleDidBecomeActive];
    [[EvernoteSession sharedSession] handleDidBecomeActive];
    
    
    [[RevMobAds session] showFullscreen];
    
//    [[RevMobAds session]openAdLinkWithDelegate:self];
    
    
    
    //Chartboost
    Chartboost * cb = [Chartboost sharedChartboost];
    cb.appId = ChartboostID;
    cb.appSignature = ChartboostSignature;
    cb.delegate = self;
    [cb startSession];
        
    
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    [SHKFacebook handleWillTerminate];
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSString* scheme = [url scheme];
    
    if ([scheme hasPrefix:[NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)]]) {
        return [SHKFacebook handleOpenURL:url];
    }
    
    return YES;
}

- (void)testOffline
{
	[SHK flushOfflineQueue];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
//    [currentInstallation setChannels:[[NSArray alloc] initWithObjects:@"a", nil]];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNotification" object:nil userInfo:userInfo];
}



#pragma Revmob Delegate Methods.

-(void)revmobAdDidFailWithError:(NSError *)error
{
    NSLog(@"Ad failed with error : %@", error);
}
-(void)revmobAdDidReceive
{
    NSLog(@"Ad loaded successfully");
}
-(void)revmobAdDisplayed
{
    NSLog(@"Ad displayed");
}
-(void)revmobUserClickedInTheAd
{
    NSLog(@"User clicked in the ad");
}
-(void)revmobUserClosedTheAd
{
    NSLog(@"User closed the ad");
}


#pragma Chartboost Delegate Method


- (BOOL)shouldDisplayInterstitial:(NSString *)location {
    NSLog(@"about to display interstitial at location %@", location);
    
    // For example:
    // if the user has left the main menu and is currently playing your game, return NO;
    
    // Otherwise return YES to display the interstitial
    return YES;
}


/*
 * didFailToLoadInterstitial
 *
 * This is called when an interstitial has failed to load. The error enum specifies
 * the reason of the failure
 */

- (void)didFailToLoadInterstitial:(NSString *)location withError:(CBLoadError)error {
    switch(error){
        case CBLoadErrorInternetUnavailable: {
            NSLog(@"Failed to load Interstitial, no Internet connection !");
        } break;
        case CBLoadErrorInternal: {
            NSLog(@"Failed to load Interstitial, internal error !");
        } break;
        case CBLoadErrorNetworkFailure: {
            NSLog(@"Failed to load Interstitial, network error !");
        } break;
        case CBLoadErrorWrongOrientation: {
            NSLog(@"Failed to load Interstitial, wrong orientation !");
        } break;
        case CBLoadErrorTooManyConnections: {
            NSLog(@"Failed to load Interstitial, too many connections !");
        } break;
        case CBLoadErrorFirstSessionInterstitialsDisabled: {
            NSLog(@"Failed to load Interstitial, first session !");
        }   break;
        case CBLoadErrorNoAdFound : {
            NSLog(@"Failed to load Interstitial, no ad found !");
        }
        default: {
            NSLog(@"Failed to load Interstitial, unknown error !");
        }
    }
}

/*
 * didCacheInterstitial
 *
 * Passes in the location name that has successfully been cached.
 *
 * Is fired on:
 * - All assets loaded
 * - Triggered by cacheInterstitial
 *
 * Notes:
 * - Similar to this is: (BOOL)hasCachedInterstitial:(NSString *)location;
 * Which will return true if a cached interstitial exists for that location
 */

- (void)didCacheInterstitial:(NSString *)location {
    NSLog(@"interstitial cached at location %@", location);
}

/*
 * didFailToLoadMoreApps
 *
 * This is called when the more apps page has failed to load for any reason
 *
 * Is fired on:
 * - No network connection
 * - No more apps page has been created (add a more apps page in the dashboard)
 * - No publishing campaign matches for that user (add more campaigns to your more apps page)
 *  -Find this inside the App > Edit page in the Chartboost dashboard
 */

- (void)didFailToLoadMoreApps:(CBLoadError)error {
    switch(error){
        case CBLoadErrorInternetUnavailable: {
            NSLog(@"Failed to load More Apps, no Internet connection !");
        } break;
        case CBLoadErrorInternal: {
            NSLog(@"Failed to load More Apps, internal error !");
        } break;
        case CBLoadErrorNetworkFailure: {
            NSLog(@"Failed to load More Apps, network error !");
        } break;
        case CBLoadErrorWrongOrientation: {
            NSLog(@"Failed to load More Apps, wrong orientation !");
        } break;
        case CBLoadErrorTooManyConnections: {
            NSLog(@"Failed to load More Apps, too many connections !");
        } break;
        case CBLoadErrorFirstSessionInterstitialsDisabled: {
            NSLog(@"Failed to load More Apps, first session !");
        } break;
        case CBLoadErrorNoAdFound: {
            NSLog(@"Failed to load More Apps, Apps not found !");
        }
        default: {
            NSLog(@"Failed to load More Apps, unknown error !");
        }
    }
}

/*
 * didDismissInterstitial
 *
 * This is called when an interstitial is dismissed
 *
 * Is fired on:
 * - Interstitial click
 * - Interstitial close
 *
 * #Pro Tip: Use the delegate method below to immediately re-cache interstitials
 */

- (void)didDismissInterstitial:(NSString *)location {
    NSLog(@"dismissed interstitial at location %@", location);
    [[Chartboost sharedChartboost] cacheInterstitial:location];
}

/*
 * didDismissMoreApps
 *
 * This is called when the more apps page is dismissed
 *
 * Is fired on:
 * - More Apps click
 * - More Apps close
 *
 * #Pro Tip: Use the delegate method below to immediately re-cache the more apps page
 */

- (void)didDismissMoreApps {
    NSLog(@"dismissed more apps page, re-caching now");
    [[Chartboost sharedChartboost] cacheMoreApps];
}

/*
 * shouldRequestInterstitialsInFirstSession
 *
 * This sets logic to prevent interstitials from being displayed until the second startSession call
 *
 * The default is YES, meaning that it will always request & display interstitials.
 * If your app displays interstitials before the first time the user plays the game, implement this method to return NO.
 */

- (BOOL)shouldRequestInterstitialsInFirstSession {
    return YES;
}

@end
