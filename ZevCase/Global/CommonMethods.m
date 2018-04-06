//
//  CommonMethods.m
//  Chat24Seven
//
//  Created by Yu Li on 03/11/11.
//

#import "CommonMethods.h"
#import <QuartzCore/QuartzCore.h>

@implementation CommonMethods

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}

+ (void)showAlertUsingTitle:(NSString *)titleString andMessage:(NSString *)messageString {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:titleString message:messageString delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];

}

+ (void) showLoadingView:(UIView *) toView title:(NSString *) title andDescription:(NSString *)desc {
  dispatch_async(dispatch_get_main_queue(), ^{
    //some UI methods ej
     UIView *tempView = [CommonMethods addLoadingViewWithTitle:title andDescription:desc];
    [toView addSubview:tempView];
  });
}

+ (void) removeLoadingView:(UIView *) myView {
  
  NSArray *tempArray = [[myView subviews] copy];
  for (UIView*tempView in tempArray) {
    if (tempView.tag == 2000) {
      
      dispatch_async(dispatch_get_main_queue(), ^{
        [tempView removeFromSuperview];
      });
    }
  }
}

+ (UIView *) addLoadingViewWithTitle:(NSString *)title
					 andDescription:(NSString *)description
{
	UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	backGroundView.backgroundColor = [UIColor clearColor];
	backGroundView.tag = 2000;
	backGroundView.alpha = 0.9;
  
	UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(40, 145, 240, 110)];
	loadingView.backgroundColor = [UIColor blackColor];
	[loadingView.layer setCornerRadius:6.0];
	[loadingView.layer setBorderWidth:2.0];
	[loadingView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
	
	UILabel  *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 200, 30)];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.text = [NSString stringWithFormat:@"%@",title];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:16];
	
	UILabel  *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 37, 240, 1)];
	lineLabel.backgroundColor = [UIColor lightGrayColor];
  
	UILabel  *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 30, 200, 60)];
	descriptionLabel.backgroundColor = [UIColor clearColor];
	descriptionLabel.numberOfLines = 3;
	descriptionLabel.text = [NSString stringWithFormat:@"%@",description];
	descriptionLabel.textColor = [UIColor whiteColor];
  
	if ([description length] < 50) {
		descriptionLabel.font = [UIFont systemFontOfSize:15];
		loadingView.frame = CGRectMake(40, 145, 240, 90);
	}
	else {
		descriptionLabel.font = [UIFont systemFontOfSize:13];
		loadingView.frame = CGRectMake(40, 145, 240, 95);
	}
	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]
													  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	
	activityIndicatorView.center = CGPointMake(15, 62);
	[activityIndicatorView startAnimating];
  
  [loadingView addSubview:titleLabel];
  [loadingView addSubview:lineLabel];
  [loadingView addSubview:descriptionLabel];
  [loadingView addSubview:activityIndicatorView];
  [backGroundView addSubview:loadingView];
  
 	return backGroundView;
}

+ (NSNumber *)getCurrentUserID {
 // DEBUGLog(@"Current UserID %d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"] intValue]);
    int userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"] intValue];
    NSNumber *userIDNumber = [NSNumber numberWithInt:userId];
    return userIDNumber;
    
}

+ (NSString *)getVersionNumber {
    NSString * appVersionString = [[NSBundle mainBundle] 
                                   objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSLog(@"app version no. is:%@",appVersionString);
    return appVersionString;
}

+ (void) changeUserImage:(NSDictionary *)responseDictionary{
     
    [[NSUserDefaults standardUserDefaults]setObject:[responseDictionary objectForKey:@"pimage"] forKey:@"userProfileImage"];
}

+ (NSString *)getUserImage{
  NSString *imageString = [[NSUserDefaults standardUserDefaults]objectForKey:@"userProfileImage"] ;
    return imageString;
}

@end
