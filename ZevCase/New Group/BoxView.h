//
//  BoxView.h
//  ZevCase
//
//  Created by Liming Zhang on 11/8/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "Global.h"


@interface BoxView : UIView{
    UIImageView *_imgBox;
    
    NSArray             *arrayFilter;
}
@property (nonatomic, assign) NSString *strMask;

- (void)setImage:(UIImage *)image;
- (void)setMask:(NSString *)mask;
- (void)setBorder : (BOOL)bShow;
- (void)setBoxHidden : (BOOL)bShow;
- (UIImage*)getImage;
@end
