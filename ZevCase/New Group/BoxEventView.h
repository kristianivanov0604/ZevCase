//
//  BoxEventView.h
//  ZevCase
//
//  Created by threek on 2/7/14.
//  Copyright (c) 2014 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BoxEventView;

@protocol BoxEventViewDelegate <NSObject>

@optional;
- (void) BoxEventView:(BoxEventView*)eventView originalImage:(UIImage *)image index:(int)index;

@end

@interface BoxEventView : UIView
{
    
}

@property (nonatomic, weak) UIImage *originalImage;
@property int  index;
@property (nonatomic, strong) id<BoxEventViewDelegate> delegate;


@end
