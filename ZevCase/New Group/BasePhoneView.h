//
//  BasePhoneView.h
//  ZevCase
//
//  Created by Liming Zhang on 11/5/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
#import "BoxView.h"
#import "BoxEventView.h"  // insert by 3K  Feb-07, 2014

@class MainViewController;

@interface BasePhoneView : UIView<UIGestureRecognizerDelegate>{
    NSArray                 *arrayBoxes;
//    NSMutableArray          *arrayImages;
    UIImageView             *_phoneImage;
    UIImageView             *_phoneOverlayImage;
    UIImageView             *dragImageView;
    UIImage                 *maskedImage;
    CGPoint                 _priorPoint;
    
    NSMutableArray          *arrayOverlayImage;

    // insert by 3K  Feb-07, 2014
    MainViewController      *parentViewController;

}

@property (nonatomic, retain) NSMutableArray    *arrayOverlayViews;
@property (nonatomic, retain) NSMutableArray    *arrayImages;

// insert by 3K  Feb-07, 2014
@property (nonatomic, retain) NSMutableArray    *arrayImageRectOfEvent;


- (id)initWithFrame:(CGRect)frame parent:(MainViewController *)parent;

- (void)setImageAtIndex:(UIImage*)image index:(int)index;
- (void) setOriginalImage:(UIImage *)image index:(int)index;    // insert by 3K  Feb-07, 2014
- (void)addOverlayImage:(UIImage*)image;
- (void)setRandomImages:(NSArray*)arrayImage;
- (void)removeAllImages;
- (void)setImageArray;
- (void) setBoxEventViewShow:(BOOL)flag;

@end
