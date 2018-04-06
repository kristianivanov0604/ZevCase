//
//  CommonMethods.h
//  Chat24Seven
//
//  Created by Yu Li on 03/11/11.
//

#import <Foundation/Foundation.h>

@interface CommonMethods : NSObject {
    
}

+ (void)showAlertUsingTitle:(NSString *)titleString andMessage:(NSString *)messageString;
+ (UIView *) addLoadingViewWithTitle:(NSString *)title
					 andDescription:(NSString *)description;
+ (NSNumber *)getCurrentUserID;
+ (NSString *)getVersionNumber;
+ (void) changeUserImage:(NSDictionary *)responseDictionary;
+ (NSString *)getUserImage;
+ (void) showLoadingView:(UIView *) toView title:(NSString *) title andDescription:(NSString *)desc;
+ (void) removeLoadingView:(UIView *) myView;
@end
