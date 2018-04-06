//
//  SingleLine.m
//  LessonMaker
//
//  Created by Hae Yon on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SingleLine.h"

@implementation SingleLine

static NSArray *colorArray = nil;

@synthesize color;
@synthesize _penWidth;

- (id)init
{
    self = [super init];
    if (self) {
        
        _vertexes = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)initWithColor:(NSInteger)colorIndex
{
    self = [super init];
    if (self) {
        
        _vertexes = [[NSMutableArray alloc] init];
        _color = colorIndex;
        if (!colorArray) {

            colorArray = [[NSArray alloc] initWithObjects:[UIColor blackColor], [UIColor whiteColor], [UIColor darkGrayColor], [UIColor lightGrayColor], [UIColor redColor], [UIColor magentaColor], [UIColor blueColor], [UIColor orangeColor], [UIColor greenColor], [UIColor yellowColor], nil];
        }
        
    }
    
    return self;
}

- (void)addVertex:(CGPoint)point
{
    [_vertexes addObject:NSStringFromCGPoint(point)];
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 4);
    CGContextSetStrokeColorWithColor(context, [[colorArray objectAtIndex:_color] CGColor]);

    CGContextBeginPath(context);
    CGPoint pt0, pt1, pt2, pt3, b0, b1, b2, b3;
    pt0 = CGPointFromString([_vertexes objectAtIndex:0]);
    pt1 = CGPointFromString([_vertexes objectAtIndex:1]);
    CGContextMoveToPoint(context, pt0.x, pt0.y);
    CGContextAddLineToPoint(context, pt1.x, pt1.y);
    for (int i = 3; i < [_vertexes count]; i ++) {
        
        pt0 = CGPointFromString([_vertexes objectAtIndex:i - 3]);
        pt1 = CGPointFromString([_vertexes objectAtIndex:i - 2]);
        pt2 = CGPointFromString([_vertexes objectAtIndex:i - 1]);
        pt3 = CGPointFromString([_vertexes objectAtIndex:i]);
        b0 = pt1;
        b1 = CGPointMake(pt1.x + (pt2.x - pt0.x) / 6, pt1.y + (pt2.y - pt0.y) / 6);
        b2 = CGPointMake(pt2.x + (pt1.x - pt3.x) / 6, pt2.y + (pt1.y - pt3.y) / 6);
        b3 = pt2;
        CGContextMoveToPoint(context, b0.x, b0.y);
        CGContextAddCurveToPoint(context, b1.x, b1.y, b2.x, b2.y, b3.x, b3.y);
//        CGPoint pt1, pt2;
//        pt1 = CGPointFromString([_vertexes objectAtIndex:i - 1]);
//        pt2 = CGPointFromString([_vertexes objectAtIndex:i]);
//        CGContextMoveToPoint(context, pt1.x, pt1.y);
//        CGContextAddLineToPoint(context, pt2.x, pt2.y);
    }
    CGContextStrokePath(context);
}

- (void)setPenWidth:(float)penWidth
{
    _penWidth = penWidth;
}

- (void)drawLastItem:(CGContextRef)context
{
    if ([_vertexes count] < 3) {

        return;
    }

    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, _penWidth);
    if (_color == -1) {

        CGContextSetLineWidth(context, _penWidth);
        CGContextSetBlendMode(context, kCGBlendModeClear);
    }
    else {

        CGContextSetStrokeColorWithColor(context, [[colorArray objectAtIndex:_color] CGColor]);
    }

    CGPoint pt0, pt1, pt2, pt3, b0, b1, b2, b3;
    pt1 = CGPointFromString([_vertexes objectAtIndex:[_vertexes count] - 3]);
    pt0 = [_vertexes count] > 3 ? CGPointFromString([_vertexes objectAtIndex:[_vertexes count] - 4]) : pt1;
    pt2 = CGPointFromString([_vertexes objectAtIndex:[_vertexes count] - 2]);
    pt3 = CGPointFromString([_vertexes objectAtIndex:[_vertexes count] - 1]);
    b0 = pt1;
    b1 = CGPointMake(pt1.x + (pt2.x - pt0.x) / 6, pt1.y + (pt2.y - pt0.y) / 6);
    b2 = CGPointMake(pt2.x + (pt1.x - pt3.x) / 6, pt2.y + (pt1.y - pt3.y) / 6);
    b3 = pt2;
    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, pt1.x, pt1.y);
//    CGContextAddLineToPoint(context, pt2.x, pt2.y);
    CGContextMoveToPoint(context, b0.x, b0.y);
    CGContextAddCurveToPoint(context, b1.x, b1.y, b2.x, b2.y, b3.x, b3.y);
    CGContextStrokePath(context);
}

- (void)dealloc
{
    [_vertexes removeAllObjects];

    [super dealloc];
}

@end