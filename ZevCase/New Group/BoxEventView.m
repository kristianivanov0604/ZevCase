//
//  BoxEventView.m
//  ZevCase
//
//  Created by threek on 2/7/14.
//  Copyright (c) 2014 Yu Li. All rights reserved.
//

#import "BoxEventView.h"

@implementation BoxEventView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        [self setBackgroundColor:[UIColor colorWithWhite:0.3f alpha:0.3f]];
        [self setBackgroundColor:[UIColor clearColor]];
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) imageTapAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"TAP______");
    if (self.originalImage) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(BoxEventView:originalImage:index:)]) {
            [self.delegate BoxEventView:self originalImage:self.originalImage index:self.index];
        }
    }
}

@end
