//
//  SingleLine.h
//  LessonMaker
//
//  Created by Hae Yon on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleLine : NSObject {
    
    NSMutableArray *_vertexes;
    NSInteger       _color;
    float          _penWidth;
}

@property NSInteger color;
@property float _penWidth;

- (id)initWithColor:(NSInteger)colorIndex;
- (void)addVertex:(CGPoint)point;
- (void)drawInContext:(CGContextRef)context;
- (void)setPenWidth:(float)penWidth;
- (void)drawLastItem:(CGContextRef)context;

@end

