//
//  ImageFilter.h
//  iphone-filters
//
//  Created by Eric Silverberg on 6/16/11.
//  Copyright 2011 Perry Street Software, Inc. 
//
//  Licensed under the MIT License.
//

#import <Foundation/Foundation.h>

enum {
    CurveChannelNone                 = 0,
    CurveChannelRed					 = 1 << 0,
    CurveChannelGreen				 = 1 << 1,
    CurveChannelBlue				 = 1 << 2,
};

struct SImage
{
	int nWidth;
	int nHeight;
	unsigned char** ppbR;
	unsigned char** ppbG;
	unsigned char** ppbB;
   	unsigned char** ppbA;
};

typedef NSUInteger CurveChannel;

@interface UIImage (ImageFilter)

/* Filters */
- (UIImage*) greyscale;
- (UIImage*) sepia;
- (UIImage*) posterize:(int)levels;
- (UIImage*) saturate:(double)amount;
- (UIImage*) brightness:(double)amount;
- (UIImage*) gamma:(double)amount;
- (UIImage*) opacity:(double)amount;
- (UIImage*) contrast:(double)amount;
- (UIImage*) bias:(double)amount;
- (UIImage*) flip:(UIImage*)pInImage;


- (UIImage *) convertBitmapRGBA8ToUIImage:(unsigned char *) buffer
                               withWidth:(int) width
                              withHeight:(int) height;

- (UIImage *)scaleAndRotateImage:(UIImage *)image ;
/* Color Correction */
- (UIImage*) levels:(NSInteger)black mid:(NSInteger)mid white:(NSInteger)white;
- (UIImage*) applyCurve:(NSArray*)points toChannel:(CurveChannel)channel;
- (UIImage*) adjust:(double)r g:(double)g b:(double)b;

/* Convolve Operations */
- (UIImage*) sharpen;
- (UIImage*)soften;
- (UIImage*) edgeDetect;
- (UIImage*) gaussianBlur:(NSUInteger)radius;
- (UIImage*) vignette;
- (UIImage*) darkVignette;

/* Blend Operations */
- (UIImage*) overlay:(UIImage*)other;

/* Pre-packed filter sets */
- (UIImage*) lomo;

struct SImage*		NewImage(int nW, int nH);
void		DeleteImage(struct SImage* pImage);
struct SImage* UIImage2SImage(UIImage* Image);
UIImage* SImage2UIImage(struct SImage* pImage);
UIImage* MakeRGBAImage(UIImage* image);
@end
