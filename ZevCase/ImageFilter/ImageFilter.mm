//
//  ImageFilter.m
//  iphone-filters
//
//  Created by Eric Silverberg on 6/16/11.
//  Copyright 2011 Perry Street Software, Inc. 
//
//  Licensed under the MIT License.
//

#include <math.h>
#import "ImageFilter.h"
//#import "CatmullRomSpline.h"

#define SAFECOLOR(color) MIN(255,MAX(0,color))

typedef void (*FilterCallback)(UInt8 *pixelBuf, UInt32 offset, void *context);
typedef void (*FilterBlendCallback)(UInt8 *pixelBuf, UInt8 *pixelBlendBuf, UInt32 offset, void *context);

@implementation UIImage (ImageFilter)

#pragma mark -
#pragma mark Basic Filters
#pragma mark Internals

static CGContextRef
createARGBBitmapContextFromImage(UIImage* inImage)
{
	CGContextRef    context = NULL;
	CGColorSpaceRef colorSpace;
	void *          bitmapData;
	int             bitmapByteCount;
	int             bitmapBytesPerRow;
	size_t pixelsWide, pixelsHigh;
	
	// Get image width, height. We'll use the entire image.
	
	pixelsWide = inImage.size.width;
	pixelsHigh = inImage.size.height;
	
	// Declare the number of bytes per row. Each pixel in the bitmap in this
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
	// alpha.
	bitmapBytesPerRow   = (pixelsWide * 4);
	bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	
	// Use the generic RGB color space.
	colorSpace = CGColorSpaceCreateDeviceRGB();
	
	if (colorSpace == NULL)
	{
		fprintf(stderr, "Error allocating color space\n");
		return NULL;
	}
	
	// Allocate memory for image data. This is the destination in memory
	// where any drawing to the bitmap context will be rendered.
	bitmapData = malloc( bitmapByteCount );
	if (bitmapData == NULL) 
	{
		fprintf (stderr, "Memory not allocated!");
		CGColorSpaceRelease( colorSpace );
		return NULL;
	}
	
	// Create the bitmap context. We want pre-multiplied ARGB, 8-bits 
	// per component. Regardless of what the source image format is 
	// (CMYK, Grayscale, and so on) it will be converted over to the format
	// specified here by CGBitmapContextCreate.
	context = CGBitmapContextCreate (bitmapData,
									 pixelsWide,
									 pixelsHigh,
									 8,      // bits per component
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaPremultipliedFirst);
	if (context == NULL)
	{
		free (bitmapData);
		fprintf (stderr, "Context not created!");
	}
	
	// Make sure and release colorspace before returning
	CGColorSpaceRelease( colorSpace );
	
	return context;
}

UIImage* SImage2UIImage(struct SImage* pImage)
{
	int nWidth = pImage->nWidth;
	int nHeight = pImage->nHeight;
	char *resultBuffer = (char*) malloc(nHeight * nWidth * 4);
	int iW =0, iH =0, offset = 0;
	
	for(iH =0; iH < nHeight; iH++)
	{
		for(iW =0; iW < nWidth; iW++)
		{
			resultBuffer[offset] = pImage->ppbR[iH][iW]; 
			resultBuffer[offset+1] = pImage->ppbG[iH][iW];
 			resultBuffer[offset+2] = pImage->ppbB[iH][iW];
            resultBuffer[offset+3] = pImage->ppbA[iH][iW];
			offset += 4;
		}
	}
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef ctx = CGBitmapContextCreate(resultBuffer, 
											 nWidth , 
											 nHeight , 
											 8, 
											 nWidth*4, 
											 colorSpace, 
											 kCGImageAlphaPremultipliedLast ); 
	
	CGImageRef imageRef = CGBitmapContextCreateImage (ctx); 
	UIImage* rawImage = [UIImage imageWithCGImage:imageRef]; 
	CGColorSpaceRelease( colorSpace );
	CGImageRelease(imageRef);
	CGContextRelease(ctx);
	free(resultBuffer);
	return rawImage;
}

SImage* UIImage2SImage(UIImage* Image)
{
	int iW =0, iH =0;
	float xVar, yVar;
	UIImageOrientation imageOrientation = Image.imageOrientation;
	
	CGImageRef inImage = Image.CGImage;
	// Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
	CGContextRef cgctx = createARGBBitmapContextFromImage(Image);
	if (cgctx == NULL) { return NULL; /* error */ }
	
    size_t w = CGBitmapContextGetWidth(cgctx);
	size_t h = CGBitmapContextGetHeight(cgctx);
    
	SImage* pSImage = NewImage (w, h);
	
	CGRect rect;  
	
	switch (imageOrientation) {
		case UIImageOrientationDown:
		case UIImageOrientationDownMirrored:
			xVar = w / 2 * cos(M_PI) - h / 2 * sin(M_PI) - w / 2;
			yVar = w / 2 * sin(M_PI) + h / 2 * cos(M_PI) - h / 2;
			CGContextTranslateCTM(cgctx, -xVar, -yVar);
			CGContextRotateCTM(cgctx, M_PI);
			rect = CGRectMake(0, 0, w, h);
			break;
		case UIImageOrientationLeft:
		case UIImageOrientationLeftMirrored:
			xVar = h / 2 * cos(M_PI/2) - w / 2 * sin(M_PI/2) - w / 2;
			yVar = h / 2 * sin(M_PI/2) + w / 2 * cos(M_PI/2) - h/ 2;
			CGContextTranslateCTM(cgctx, -xVar, -yVar);
			CGContextRotateCTM(cgctx, M_PI / 2);
			rect = CGRectMake(0, 0, h, w);
			break;
		case UIImageOrientationRight:
		case UIImageOrientationRightMirrored:
			xVar = h / 2 * cos(-M_PI/2) - w / 2 * sin(-M_PI/2) - w / 2;
			yVar = h / 2 * sin(-M_PI/2) + w / 2 * cos(-M_PI/2) - h / 2;
			CGContextTranslateCTM(cgctx, -xVar, -yVar);
			CGContextRotateCTM(cgctx, -M_PI / 2);
			rect = CGRectMake(0, 0, h, w);
			break;
		case UIImageOrientationUp:
		case UIImageOrientationUpMirrored:
			rect = CGRectMake(0, 0, w, h);
			break;
		default:
			break;
	}
	
	// Draw the image to the bitmap context. Once we draw, the memory 
	// allocated for the context for rendering will then contain the 
	// raw image data in the specified color space.
	CGContextDrawImage(cgctx, rect, inImage); 
	
	// Now we can get a pointer to the image data associated with the bitmap
	// context.
	unsigned char* data = (unsigned char *)CGBitmapContextGetData (cgctx);
	if (data != NULL)
	{
		//offset locates the pixel in the data from x,y. 
		//4 for 4 bytes of data per pixel, w is width of one row of data.
		int offset =0;
		for(iH =0; iH < h; iH++)
		{
			for(iW =0; iW < w; iW++)
			{
                pSImage->ppbA[iH][iW] = data[offset];
				pSImage->ppbR[iH][iW] = data[offset+1];
				pSImage->ppbG[iH][iW] = data[offset+2];
				pSImage->ppbB[iH][iW] = data[offset+3];
				offset += 4;
			}
		}
	}
	
	// When finished, release the context
	CGContextRelease(cgctx); 
	// Free image data memory for the context
	if (data) { free(data); }
	return pSImage;
}

UIImage* MakeRGBAImage(UIImage* image)
{
    struct SImage* pImage = UIImage2SImage(image);
    image = SImage2UIImage(pImage);
    DeleteImage(pImage);
    return image;
}

- (UIImage*) applyFilter:(FilterCallback)filter context:(void*)context
{
    self = MakeRGBAImage(self);
	CGImageRef inImage = self.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    UInt8 * pixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);
//	UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);
    
    int length = CFDataGetLength(m_DataRef);
    unsigned char *m_PixelBuf = (unsigned char *)malloc(length);
    memcpy(m_PixelBuf, pixelBuf, length);
    
	for (int i=0; i<length; i+=4)
	{
		filter(m_PixelBuf,i,context);
	}
	size_t nWidth = CGImageGetWidth(inImage);
    size_t nHeight = CGImageGetHeight(inImage);
//    size_t bitsPerComp = CGImageGetBitsPerComponent(inImage);
//    size_t nBytePerRow = CGImageGetBytesPerRow(inImage);
//	CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,  
//											 CGImageGetWidth(inImage),  
//											 CGImageGetHeight(inImage),  
//											 CGImageGetBitsPerComponent(inImage),
//											 CGImageGetBytesPerRow(inImage),  
//											 CGImageGetColorSpace(inImage),  
//											 CGImageGetBitmapInfo(inImage) 
//											 ); 
//	
//	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);  
//	CGContextRelease(ctx);
//	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
//	CGImageRelease(imageRef);
//	CFRelease(m_DataRef);
    UIImage *finalImage = [self convertBitmapRGBA8ToUIImage:m_PixelBuf withWidth:nWidth withHeight:nHeight];
      
	return finalImage;
	
}



-(UIImage *) convertBitmapRGBA8ToUIImage:(unsigned char *) buffer
                                withWidth:(int) width
                               withHeight:(int) height {
    
    
    size_t bufferLength = width * height * 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, bufferLength, NULL);
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 32;
    size_t bytesPerRow = 4 * width;
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    if(colorSpaceRef == NULL) {
        NSLog(@"Error allocating color space");
        CGDataProviderRelease(provider);
        return nil;
    }
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef iref = CGImageCreate(width,
                                    height,
                                    bitsPerComponent,
                                    bitsPerPixel,
                                    bytesPerRow,
                                    colorSpaceRef,
                                    bitmapInfo,
                                    provider, // data provider
                                    NULL, // decode
                                    YES, // should interpolate
                                    renderingIntent);
    
    uint32_t* pixels = (uint32_t*)malloc(bufferLength);
    
    if(pixels == NULL) {
        NSLog(@"Error: Memory not allocated for bitmap");
        CGDataProviderRelease(provider);
        CGColorSpaceRelease(colorSpaceRef);
        CGImageRelease(iref);
        return nil;
    }
    
    CGContextRef context = CGBitmapContextCreate(pixels,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpaceRef,
                                                 bitmapInfo);
    
    if(context == NULL) {
        NSLog(@"Error context not created");
        free(pixels);
    }
    
    UIImage *image = nil;
    if(context) {
        
        CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), iref);
        
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        
        // Support both iPad 3.2 and iPhone 4 Retina displays with the correct scale
        if([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
            float scale = [[UIScreen mainScreen] scale];
            image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
        } else {
            image = [UIImage imageWithCGImage:imageRef];
        }
        
        CGImageRelease(imageRef);
        CGContextRelease(context);
    }
    
    CGColorSpaceRelease(colorSpaceRef);
    CGImageRelease(iref);
    CGDataProviderRelease(provider);
    
    if(pixels) {
        free(pixels);
    }
    return image;
}

struct SImage*		NewImage(int nW, int nH)
{
	int i;
	struct SImage* pImg = new struct SImage;
	pImg->nWidth = nW;
	pImg->nHeight = nH;
 	pImg->ppbA = new unsigned char*[nH];
	pImg->ppbA[0] = new unsigned char[nH*nW];   
	pImg->ppbR = new unsigned char*[nH];
	pImg->ppbR[0] = new unsigned char[nH*nW];
	pImg->ppbG = new unsigned char*[nH];
	pImg->ppbG[0] = new unsigned char[nH*nW];
	pImg->ppbB = new unsigned char*[nH];
	pImg->ppbB[0] = new unsigned char[nH*nW];
	for (i = 1; i < nH; i ++)
	{
        pImg->ppbA[i] = &pImg->ppbA[0][nW * i];
		pImg->ppbR[i] = &pImg->ppbR[0][nW * i];
		pImg->ppbG[i] = &pImg->ppbG[0][nW * i];
		pImg->ppbB[i] = &pImg->ppbB[0][nW * i];
	}
	return pImg;
}

void		DeleteImage(struct SImage* pImage)
{
	delete pImage->ppbR[0];
	delete pImage->ppbR;
	delete pImage->ppbG[0];
	delete pImage->ppbG;
	delete pImage->ppbB[0];
	delete pImage->ppbB;
    delete pImage->ppbA[0];
    delete pImage->ppbA;
	delete pImage;
}

UIImage*    CombineTwoImage(UIImage* pFirstImage, UIImage* pSecondImage)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    int width = CGImageGetWidth(pFirstImage.CGImage);
    int height  = CGImageGetHeight(pFirstImage.CGImage);
    
    if (width < CGImageGetWidth(pSecondImage.CGImage))
        return nil;
    if (height != CGImageGetHeight(pSecondImage.CGImage))
        return nil;
    
    CGContextRef buf_context = CGBitmapContextCreate(nil, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    CGRect rect = CGRectMake(0,0, width, height);
    
    UIGraphicsPushContext(buf_context);
    CGContextClearRect(buf_context, rect);
    CGContextDrawImage(buf_context, rect, pFirstImage.CGImage);
    CGContextDrawImage(buf_context, rect, pSecondImage.CGImage);
    UIGraphicsPopContext();
    
    CGImageRef image = CGBitmapContextCreateImage(buf_context);
    CGContextRelease(buf_context);
    
    UIImage* img = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
    return img;
}

#pragma mark C Implementation
void filterGreyscale(UInt8 *pixelBuf, UInt32 offset, void *context)
{	
	int r = offset;
	int g = offset+1;
	int b = offset+2;
    int  a = offset + 3;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	int alpha = pixelBuf[a];
    
	uint32_t gray = 0.3 * red + 0.59 * green + 0.11 * blue;
	
	pixelBuf[r] = gray;
	pixelBuf[g] = gray;
	pixelBuf[b] = gray;
    pixelBuf[a] = alpha;
}

void filterSepia(UInt8 *pixelBuf, UInt32 offset, void *context)
{	
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR((red * 0.393) + (green * 0.769) + (blue * 0.189));
	pixelBuf[g] = SAFECOLOR((red * 0.349) + (green * 0.686) + (blue * 0.168));
	pixelBuf[b] = SAFECOLOR((red * 0.272) + (green * 0.534) + (blue * 0.131));
}

void filterPosterize(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	int levels = *((int*)context);
	int step = 255 / levels;
	
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR((red / step) * step);
	pixelBuf[g] = SAFECOLOR((green / step) * step);
	pixelBuf[b] = SAFECOLOR((blue / step) * step);
}


void filterSaturate(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	double t = *((double*)context);
	
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	int avg = ( red + green + blue ) / 3;
	
	pixelBuf[r] = SAFECOLOR((avg + t * (red - avg)));
	pixelBuf[g] = SAFECOLOR((avg + t * (green - avg)));
	pixelBuf[b] = SAFECOLOR((avg + t * (blue - avg)));	
}

void filterBrightness(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	double t = *((double*)context);
	
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR(red*t);
	pixelBuf[g] = SAFECOLOR(green*t);
	pixelBuf[b] = SAFECOLOR(blue*t);
}

void filterGamma(UInt8 *pixelBuf, UInt32 offset, void *context)
{	
	double amount = *((double*)context);
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR(pow(red,amount));
	pixelBuf[g] = SAFECOLOR(pow(green,amount));
	pixelBuf[b] = SAFECOLOR(pow(blue,amount));
}

void filterOpacity(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	double val = *((double*)context);
	
	int a = offset+3;
	
	int alpha = pixelBuf[a];
	
	pixelBuf[a] = SAFECOLOR(alpha * val);
}

double calcContrast(double f, double c){
	return (f-0.5) * c + 0.5;
}

void filterContrast(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	double val = *((double*)context);
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR(255 * calcContrast((double)((double)red / 255.0f), val));
	pixelBuf[g] = SAFECOLOR(255 * calcContrast((double)((double)green / 255.0f), val));
	pixelBuf[b] = SAFECOLOR(255 * calcContrast((double)((double)blue / 255.0f), val));
}

double calcBias(double f, double bi){
	return (double) (f / ((1.0 / bi - 1.9) * (0.9 - f) + 1));
}

void filterBias(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	double val = *((double*)context);
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR((red * calcBias(((double)red / 255.0f), val)));
	pixelBuf[g] = SAFECOLOR((green * calcBias(((double)green / 255.0f), val)));
	pixelBuf[b] = SAFECOLOR((blue * calcBias(((double)blue / 255.0f), val)));
}

#pragma mark Filters
-(UIImage*)greyscale 
{
	return [self applyFilter:filterGreyscale context:nil];
}

-(UIImage*)flip:(UIImage*)pInImage
{
    SImage* pImage = UIImage2SImage(pInImage);
   
    int nWidth = pImage->nWidth;
    int nHeight = pImage->nHeight;
    SImage* pOutImage = NewImage(nWidth, nHeight);
    int nNewX;
    for (int iY = 0; iY < nHeight; iY ++)
    {
        for (int iX = 0; iX < nWidth; iX ++)
        {
            nNewX = nWidth - iX;
            pOutImage->ppbR[iY][nNewX] = pImage->ppbR[iY][iX];
            pOutImage->ppbG[iY][nNewX] = pImage->ppbG[iY][iX];
            pOutImage->ppbB[iY][nNewX] = pImage->ppbB[iY][iX];
            pOutImage->ppbA[iY][nNewX] = pImage->ppbA[iY][iX];
        }
    }
    UIImage* pOutUIImage = SImage2UIImage(pOutImage);
    DeleteImage(pImage);
    DeleteImage(pOutImage);
    return pOutUIImage;
}

- (UIImage*)sepia
{
	return [self applyFilter:filterSepia context:nil];
}

- (UIImage*)posterize:(int)levels
{
	return [self applyFilter:filterPosterize context:&levels];
}

- (UIImage*)saturate:(double)amount
{
	return [self applyFilter:filterSaturate context:&amount];
}

- (UIImage*)brightness:(double)amount
{
	return [self applyFilter:filterBrightness context:&amount];
}

- (UIImage*)gamma:(double)amount
{
	return [self applyFilter:filterGamma context:&amount];	
}

- (UIImage*)opacity:(double)amount
{
	return [self applyFilter:filterOpacity context:&amount];	
}

- (UIImage*)contrast:(double)amount
{
	return [self applyFilter:filterContrast context:&amount];
}

- (UIImage*)bias:(double)amount
{
	return [self applyFilter:filterBias context:&amount];	
}

#pragma mark -
#pragma mark Blends
#pragma mark Internals
- (UIImage*) applyBlendFilter:(FilterBlendCallback)filter other:(UIImage*)other context:(void*)context
{
	CGImageRef inImage = self.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  	
	
	CGImageRef otherImage = other.CGImage;
	CFDataRef m_OtherDataRef = CGDataProviderCopyData(CGImageGetDataProvider(otherImage));  
	UInt8 * m_OtherPixelBuf = (UInt8 *) CFDataGetBytePtr(m_OtherDataRef);  	
	
	int h = self.size.height;
	int w = self.size.width;
	
	
	for (int i=0; i<h; i++)
	{
		for (int j = 0; j < w; j++)
		{
			int index = (i*w*4) + (j*4);
			filter(m_PixelBuf,m_OtherPixelBuf,index,context);			
		}
	}  
	
	CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,  
											 CGImageGetWidth(inImage),  
											 CGImageGetHeight(inImage),  
											 CGImageGetBitsPerComponent(inImage),
											 CGImageGetBytesPerRow(inImage),  
											 CGImageGetColorSpace(inImage),  
											 CGImageGetBitmapInfo(inImage) 
											 ); 
	
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);  
	CGContextRelease(ctx);
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
    CFRelease(m_DataRef);
	CFRelease(m_OtherDataRef);
	return finalImage;
	
}
#pragma mark C Implementation
double calcOverlay(float b, float t) {
	return (b > 128.0f) ? 255.0f - 2.0f * (255.0f - t) * (255.0f - b) / 255.0f: (b * t * 2.0f) / 255.0f;
}

void filterOverlay(UInt8 *pixelBuf, UInt8 *pixedBlendBuf, UInt32 offset, void *context)
{	
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	int a = offset+3;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	int blendRed = pixedBlendBuf[r];
	int blendGreen = pixedBlendBuf[g];
	int blendBlue = pixedBlendBuf[b];
	double blendAlpha = pixedBlendBuf[a] / 255.0f;
	
	// http://en.wikipedia.org/wiki/Alpha_compositing
	//	double blendAlpha = pixedBlendBuf[a] / 255.0f;
	//	double blendRed = pixedBlendBuf[r] * blendAlpha + red * (1-blendAlpha);
	//	double blendGreen = pixedBlendBuf[g] * blendAlpha + green * (1-blendAlpha);
	//	double blendBlue = pixedBlendBuf[b] * blendAlpha + blue * (1-blendAlpha);
	
	int resultR = SAFECOLOR(calcOverlay(red, blendRed));
	int resultG = SAFECOLOR(calcOverlay(green, blendGreen));
	int resultB = SAFECOLOR(calcOverlay(blue, blendBlue));
	
	// take this result, and blend it back again using the alpha of the top guy	
	pixelBuf[r] = SAFECOLOR(resultR * blendAlpha + red * (1 - blendAlpha));
	pixelBuf[g] = SAFECOLOR(resultG * blendAlpha + green * (1 - blendAlpha));
	pixelBuf[b] = SAFECOLOR(resultB * blendAlpha + blue * (1 - blendAlpha));
	
}

void filterMask(UInt8 *pixelBuf, UInt8 *pixedBlendBuf, UInt32 offset, void *context)
{	
	int r = offset;
//	int g = offset+1;
//	int b = offset+2;
	int a = offset+3;

	// take this result, and blend it back again using the alpha of the top guy	
	pixelBuf[a] = pixedBlendBuf[r];
}

void filterMerge(UInt8 *pixelBuf, UInt8 *pixedBlendBuf, UInt32 offset, void *context)
{	
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	int a = offset+3;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	int blendRed = pixedBlendBuf[r];
	int blendGreen = pixedBlendBuf[g];
	int blendBlue = pixedBlendBuf[b];
	double blendAlpha = pixedBlendBuf[a] / 255.0f;
			
	// take this result, and blend it back again using the alpha of the top guy	
	pixelBuf[r] = SAFECOLOR(blendRed * blendAlpha + red * (1 - blendAlpha));
	pixelBuf[g] = SAFECOLOR(blendGreen * blendAlpha + green * (1 - blendAlpha));
	pixelBuf[b] = SAFECOLOR(blendBlue * blendAlpha + blue * (1 - blendAlpha));	
}

#pragma mark Filters
- (UIImage*) overlay:(UIImage*)other;
{
	return [self applyBlendFilter:filterOverlay other:other context:nil];
}

- (UIImage*) mask:(UIImage*)other;
{
	return [self applyBlendFilter:filterMask other:other context:nil];
}

- (UIImage*) merge:(UIImage*)other;
{
	return [self applyBlendFilter:filterMerge other:other context:nil];
}


#pragma mark -
#pragma mark Color Correction
#pragma mark C Implementation
typedef struct
{
	int blackPoint;
	int whitePoint;
	int midPoint;
} LevelsOptions;

int calcLevelColor(int color, int black, int mid, int white)
{
	if (color < black) {
		return 0;
	} else if (color < mid) {
		int width = (mid - black);
		double stepSize = ((double)width / 128.0f);
		return (int)((double)(color - black) / stepSize);		
	} else if (color < white) {
		int width = (white - mid);
		double stepSize = ((double)width / 128.0f);
		return 128 + (int)((double)(color - mid) / stepSize);		
	}
	
	return 255;
}
void filterLevels(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	LevelsOptions val = *((LevelsOptions*)context);
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR(calcLevelColor(red, val.blackPoint, val.midPoint, val.whitePoint));
	pixelBuf[g] = SAFECOLOR(calcLevelColor(green, val.blackPoint, val.midPoint, val.whitePoint));
	pixelBuf[b] = SAFECOLOR(calcLevelColor(blue, val.blackPoint, val.midPoint, val.whitePoint));
}

typedef struct
{
	CurveChannel channel;
	CGPoint *points;
	int length;
} CurveEquation;

double valueGivenCurve(CurveEquation equation, double xValue)
{
	assert(xValue <= 255);
	assert(xValue >= 0);
	
	CGPoint point1 = CGPointZero;
	CGPoint point2 = CGPointZero;
	NSInteger idx = 0;
	
	for (idx = 0; idx < equation.length; idx++)
	{
		CGPoint point = equation.points[idx];
		if (xValue < point.x)
		{
			point2 = point;
			if (idx - 1 >= 0)
			{
				point1 = equation.points[idx-1];
			}
			else
			{
				point1 = point2;
			}
			
			break;
		}		
	}
	
	double m = (point2.y - point1.y)/(point2.x - point1.x);
	double b = point2.y - (m * point2.x);
	double y = m * xValue + b;
	return y;
}

void filterCurve(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	CurveEquation equation = *((CurveEquation*)context);
	
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	red = equation.channel & CurveChannelRed ? valueGivenCurve(equation, red) : red;
	green = equation.channel & CurveChannelGreen ? valueGivenCurve(equation, green) : green;
	blue = equation.channel & CurveChannelBlue ? valueGivenCurve(equation, blue) : blue;
	
	pixelBuf[r] = SAFECOLOR(red);
	pixelBuf[g] = SAFECOLOR(green);
	pixelBuf[b] = SAFECOLOR(blue);
}
typedef struct 
{
	double r;
	double g;
	double b;
} RGBAdjust;


void filterAdjust(UInt8 *pixelBuf, UInt32 offset, void *context)
{
	RGBAdjust val = *((RGBAdjust*)context);
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR(red * (1 + val.r));
	pixelBuf[g] = SAFECOLOR(green * (1 + val.g));
	pixelBuf[b] = SAFECOLOR(blue * (1 + val.b));
}

#pragma mark Filters
/*
 * Levels: Similar to levels in photoshop. 
 * todo: Specify per-channel
 *
 * Parameters:
 *   black: 0-255
 *   mid: 0-255
 *   white: 0-255
 */
- (UIImage*) levels:(NSInteger)black mid:(NSInteger)mid white:(NSInteger)white
{
	LevelsOptions l;
	l.midPoint = mid;
	l.whitePoint = white;
	l.blackPoint = black;
	
	return [self applyFilter:filterLevels context:&l];
}

/*
 * Levels: Similar to curves in photoshop. 
 * todo: Use a Bicubic spline not a catmull rom spline
 *
 * Parameters:
 *   points: An NSArray of CGPoints through which the curve runs
 *   toChannel: A bitmask of the channels to which the curve gets applied
 */
//- (UIImage*) applyCurve:(NSArray*)points toChannel:(CurveChannel)channel
//{
//	assert([points count] > 1);
//	
//	CGPoint firstPoint = ((NSValue*)[points objectAtIndex:0]).CGPointValue;
//	CatmullRomSpline *spline = [CatmullRomSpline catmullRomSplineAtPoint:firstPoint];	
//	NSInteger idx = 0;
//	NSInteger length = [points count];
//	for (idx = 1; idx < length; idx++)
//	{
//		CGPoint point = ((NSValue*)[points objectAtIndex:idx]).CGPointValue;
//		[spline addPoint:point];
//		NSLog(@"Adding point %@",NSStringFromCGPoint(point));
//	}		
//	
//	NSArray *splinePoints = [spline asPointArray];		
//	length = [splinePoints count];
//	CGPoint *cgPoints = malloc(sizeof(CGPoint) * length);
//	memset(cgPoints, 0, sizeof(CGPoint) * length);
//	for (idx = 0; idx < length; idx++)
//	{
//		CGPoint point = ((NSValue*)[splinePoints objectAtIndex:idx]).CGPointValue;
//		NSLog(@"Adding point %@",NSStringFromCGPoint(point));
//		cgPoints[idx].x = point.x;
//		cgPoints[idx].y = point.y;
//	}
//	
//	CurveEquation equation;
//	equation.length = length;
//	equation.points = cgPoints;	
//	equation.channel = channel;
//	UIImage *result = [self applyFilter:filterCurve context:&equation];	
//	free(cgPoints);
//	return result;
//}


/*
 * adjust: Similar to color balance
 *
 * Parameters:
 *   r: Multiplier of r. Make < 0 to reduce red, > 0 to increase red
 *   g: Multiplier of g. Make < 0 to reduce green, > 0 to increase green
 *   b: Multiplier of b. Make < 0 to reduce blue, > 0 to increase blue
 */
- (UIImage*)adjust:(double)r g:(double)g b:(double)b
{
	RGBAdjust adjust;
	adjust.r = r;
	adjust.g = g;
	adjust.b = b;
	
	return [self applyFilter:filterAdjust context:&adjust];	
}

#pragma mark -
#pragma mark Convolve Operations
#pragma mark Internals
- (UIImage*) applyConvolve:(NSArray*)kernel
{
	CGImageRef inImage = self.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
//    NSData*  m_OutDataRef = [(NSData*) CGDataProviderCopyData(CGImageGetDataProvider(inImage)) autorelease];  
	UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  
    
//	UInt8 * m_OutPixelBuf = (UInt8 *) CFDataGetBytePtr(m_OutDataRef);  
	
	int h = CGImageGetHeight(inImage);
	int w = CGImageGetWidth(inImage);
    UInt8 * m_OutPixelBuf = (UInt8 *)malloc(w* h * 4 * sizeof(UInt8));  
    size_t bitsPerPix = CGImageGetBitsPerPixel(inImage);
    size_t bytePerRow = CGImageGetBytesPerRow(inImage);
    size_t bitsPerComponent         = CGImageGetBitsPerComponent(inImage);
    CGColorSpaceRef colorspace = CGImageGetColorSpace(inImage);
    CGBitmapInfo bmpInfo = CGImageGetBitmapInfo(inImage);
    
	
	int kh = [kernel count] / 2;
	int kw = [[kernel objectAtIndex:0] count] / 2;
	int i = 0, j = 0, n = 0, m = 0;
    int nAlpha;
    
	
	for (i = 0; i < h; i++) {
		for (j = 0; j < w; j++) {
			int outIndex = (i*w*4) + (j*4);
			double r = 0, g = 0, b = 0;
			for (n = -kh; n <= kh; n++) {
				for (m = -kw; m <= kw; m++) {
					if (i + n >= 0 && i + n < h) {
						if (j + m >= 0 && j + m < w) {
							double f = [[[kernel objectAtIndex:(n + kh)] objectAtIndex:(m + kw)] doubleValue];
							if (f == 0) {continue;}
							int inIndex = ((i+n)*w*4) + ((j+m)*4);
							r += m_PixelBuf[inIndex] * f;
							g += m_PixelBuf[inIndex + 1] * f;
							b += m_PixelBuf[inIndex + 2] * f;
						}
					}
				}
			}
			m_OutPixelBuf[outIndex]     = SAFECOLOR((int)r);
			m_OutPixelBuf[outIndex + 1] = SAFECOLOR((int)g);
			m_OutPixelBuf[outIndex + 2] = SAFECOLOR((int)b);
            nAlpha =  m_PixelBuf[outIndex + 3];
//            if(nAlpha > 128)
//                nAlpha = 128;
//			m_OutPixelBuf[outIndex + 3] = m_PixelBuf[outIndex + 3];
            m_OutPixelBuf[outIndex + 3] = SAFECOLOR(nAlpha);
		}
	}
	
    CGColorSpaceRef col = CGColorSpaceCreateDeviceRGB();
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, m_OutPixelBuf, w * h * 4, NULL);
    
    CGImageRef newImageRef = CGImageCreate(w, h,bitsPerComponent, bitsPerPix, bytePerRow, col, bmpInfo, provider, NULL, false, kCGRenderingIntentDefault);
    
    
//	CGContextRef ctx = CGBitmapContextCreate(m_OutPixelBuf,  
//											 w,  
//											 h,  
//											 bitsPerPix,
//											 bytePerRow,  
////											 colorspace,  
//                                             col,
////											 bmpInfo 
//                                             kCGImageAlphaLast
//											 ); 
//	
//	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);  
//	CGContextRelease(ctx);
	UIImage *finalImage = [UIImage imageWithCGImage:newImageRef];
//	CGImageRelease(imageRef);
	CFRelease(m_DataRef);
    CGDataProviderRelease(provider);
    CGImageRelease(newImageRef);
//    CFRelease(m_OutDataRef);
	return finalImage;
	
}
#pragma mark Filters
- (UIImage*) sharpen
{
	double dKernel[5][5]={ 
		{0, 0.0, -0.2,  0.0, 0},
		{0, -0.2, 1.8, -0.2, 0},
		{0, 0.0, -0.2,  0.0, 0}};
		
	NSMutableArray *kernel = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
	for (int i = 0; i < 5; i++) {
		NSMutableArray *row = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
		for (int j = 0; j < 5; j++) {
			[row addObject:[NSNumber numberWithDouble:dKernel[i][j]]];
		}
		[kernel addObject:row];
	}
	return [self applyConvolve:kernel];
}

-(UIImage*)soften
{
    double dKernel[3][3] = {
        {0.0625, 0.0625, 0.0625},
        {0.0625, 0.8,    0.0625},
        {0.0625, 0.0625, 0.0625}
    };
    NSMutableArray *kernel = [[[NSMutableArray alloc] initWithCapacity:3] autorelease];
	for (int i = 0; i < 3; i++) {
		NSMutableArray *row = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
		for (int j = 0; j < 3; j++) {
			[row addObject:[NSNumber numberWithDouble:dKernel[i][j]]];
		}
		[kernel addObject:row];
	}
	return [self applyConvolve:kernel];
}

- (UIImage*) edgeDetect
{
	double dKernel[5][5]={ 
		{0, 0.0, 1.0,  0.0, 0},
		{0, 1.0, -4.0, 1.0, 0},
		{0, 0.0, 1.0,  0.0, 0}};
	
	NSMutableArray *kernel = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
	for (int i = 0; i < 5; i++) {
		NSMutableArray *row = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
		for (int j = 0; j < 5; j++) {
			[row addObject:[NSNumber numberWithDouble:dKernel[i][j]]];
		}
		[kernel addObject:row];
	}
	return [self applyConvolve:kernel];
}

+ (NSArray*) makeKernel:(int)length
{
	NSMutableArray *kernel = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
	int radius = length / 2;
	
	double m = 1.0f/(2*M_PI*radius*radius);
	double a = 2.0 * radius * radius;
	double sum = 0.0;
	
	for (int y = 0-radius; y < length-radius; y++)
	{
		NSMutableArray *row = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
        for (int x = 0-radius; x < length-radius; x++)
        {
			double dist = (x*x) + (y*y);
			double val = m*exp(-(dist / a));
			[row addObject:[NSNumber numberWithDouble:val]];			
			sum += val;
        }
		[kernel addObject:row];
	}
	
	//for Kernel-Sum of 1.0
	NSMutableArray *finalKernel = [[[NSMutableArray alloc] initWithCapacity:length] autorelease];
	for (int y = 0; y < length; y++)
	{
		NSMutableArray *row = [kernel objectAtIndex:y];
		NSMutableArray *newRow = [[[NSMutableArray alloc] initWithCapacity:length] autorelease];
        for (int x = 0; x < length; x++)
        {
			NSNumber *value = [row objectAtIndex:x];
			[newRow addObject:[NSNumber numberWithDouble:([value doubleValue] / sum)]];
        }
		[finalKernel addObject:newRow];
	}
	return finalKernel;
}

- (UIImage*) gaussianBlur:(NSUInteger)radius
{
	// Pre-calculated kernel
//	double dKernel[5][5]={ 
//		{1.0f/273.0f, 4.0f/273.0f, 7.0f/273.0f, 4.0f/273.0f, 1.0f/273.0f},
//		{4.0f/273.0f, 16.0f/273.0f, 26.0f/273.0f, 16.0f/273.0f, 4.0f/273.0f},
//		{7.0f/273.0f, 26.0f/273.0f, 41.0f/273.0f, 26.0f/273.0f, 7.0f/273.0f},
//		{4.0f/273.0f, 16.0f/273.0f, 26.0f/273.0f, 16.0f/273.0f, 4.0f/273.0f},             
//		{1.0f/273.0f, 4.0f/273.0f, 7.0f/273.0f, 4.0f/273.0f, 1.0f/273.0f}};
//	
//	NSMutableArray *kernel = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
//	for (int i = 0; i < 5; i++) {
//		NSMutableArray *row = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
//		for (int j = 0; j < 5; j++) {
//			[row addObject:[NSNumber numberWithDouble:dKernel[i][j]]];
//		}
//		[kernel addObject:row];
//	}
    
    // In practice, when computing a discrete approximation of the Gaussian function, 
    // pixels at a distance of more than 3*sigma are small enough to be considered effectively zero. 
//    NSInteger r = (NSInteger)ceil(radius);
//    NSInteger rows = r*2+1;
//    CGFloat matrix[rows];
//    CGFloat sigma = radius/3;       
//    CGFloat sigma22 = 2 * sigma * sigma;
//    CGFloat sigmaPi2 = 2 * M_PI * sigma;
//    CGFloat sqrtSigmaPi2 = (CGFloat)sqrt(sigmaPi2);
//    CGFloat radius2 = radius * radius;
//    CGFloat total = 0.0;
//    
//    NSUInteger index = 0;
//    
//    for (NSInteger row = -r; row <= r; row++) {
//        CGFloat distance = row * row;
//        if (distance > radius2)
//            matrix[index] = 0;
//        else
//            matrix[index] = (CGFloat)exp(-(distance)/sigma22) / sqrtSigmaPi2;
//        total += matrix[index];
//        index++;
//    }
//    
//    for (NSUInteger i = 0; i < rows; i++)
//        matrix[i] /= total;
    NSArray* mask = [UIImage makeKernel:(radius * 2 + 1)];
	return [self applyConvolve:mask];
}

#pragma mark -
#pragma mark Pre-packaged
- (UIImage*)lomo
{
	UIImage *image = [[self saturate:1.2] contrast:1.15];
	NSArray *redPoints = [NSArray arrayWithObjects:
					   [NSValue valueWithCGPoint:CGPointMake(0, 0)],
					   [NSValue valueWithCGPoint:CGPointMake(137, 118)],
					   [NSValue valueWithCGPoint:CGPointMake(255, 255)],
						  [NSValue valueWithCGPoint:CGPointMake(255, 255)],
					   nil];
	NSArray *greenPoints = [NSArray arrayWithObjects:
						  [NSValue valueWithCGPoint:CGPointMake(0, 0)],
						  [NSValue valueWithCGPoint:CGPointMake(64, 54)],
						  [NSValue valueWithCGPoint:CGPointMake(175, 194)],
						  [NSValue valueWithCGPoint:CGPointMake(255, 255)],
						  nil];
	NSArray *bluePoints = [NSArray arrayWithObjects:
						  [NSValue valueWithCGPoint:CGPointMake(0, 0)],
						  [NSValue valueWithCGPoint:CGPointMake(59, 64)],
						   [NSValue valueWithCGPoint:CGPointMake(203, 189)],
						  [NSValue valueWithCGPoint:CGPointMake(255, 255)],
						  nil];
	image = [[[image applyCurve:redPoints toChannel:CurveChannelRed] 
			  applyCurve:greenPoints toChannel:CurveChannelGreen]
				applyCurve:bluePoints toChannel:CurveChannelBlue];
	
	return [image darkVignette];
}

- (UIImage*) vignette
{
	CGImageRef inImage = self.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  	
	int length = CFDataGetLength(m_DataRef);
	memset(m_PixelBuf,0,length);
	
	CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,  
											 CGImageGetWidth(inImage),  
											 CGImageGetHeight(inImage),  
											 CGImageGetBitsPerComponent(inImage),
											 CGImageGetBytesPerRow(inImage),  
											 CGImageGetColorSpace(inImage),  
											 CGImageGetBitmapInfo(inImage) 
											 ); 
	
	
	int borderWidth = 0.10 * self.size.width;
	CGContextSetRGBFillColor(ctx, 0,0,0,1);
	CGContextFillRect(ctx, CGRectMake(0, 0, self.size.width, self.size.height));
	CGContextSetRGBFillColor(ctx, 1.0,1.0,1.0,1);
	CGContextFillEllipseInRect(ctx, CGRectMake(borderWidth, borderWidth, 
									  self.size.width-(2*borderWidth), 
									  self.size.height-(2*borderWidth)));
	
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);  
	CGContextRelease(ctx);
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CFRelease(m_DataRef);

	UIImage *mask = [finalImage gaussianBlur:10];
	UIImage *blurredSelf = [self gaussianBlur:2];
	UIImage *maskedSelf = [self mask:mask];
	return [blurredSelf merge:maskedSelf];
}

- (UIImage*) darkVignette
{
	CGImageRef inImage = self.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  	
	int length = CFDataGetLength(m_DataRef);
	memset(m_PixelBuf,0,length);
	
	CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,  
											 CGImageGetWidth(inImage),  
											 CGImageGetHeight(inImage),  
											 CGImageGetBitsPerComponent(inImage),
											 CGImageGetBytesPerRow(inImage),  
											 CGImageGetColorSpace(inImage),  
											 CGImageGetBitmapInfo(inImage) 
											 ); 
	
	
	int borderWidth = 0.05 * self.size.width;
	CGContextSetRGBFillColor(ctx, 1.0,1.0,1.0,1);
	CGContextFillRect(ctx, CGRectMake(0, 0, self.size.width, self.size.height));
	CGContextSetRGBFillColor(ctx, 0,0,0,1);
	CGContextFillRect(ctx, CGRectMake(borderWidth, borderWidth, 
											   self.size.width-(2*borderWidth), 
											   self.size.height-(2*borderWidth)));
	
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);  
	CGContextRelease(ctx);
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);	
	
	UIImage *mask = [finalImage gaussianBlur:10];

	
	ctx = CGBitmapContextCreate(m_PixelBuf,  
											 CGImageGetWidth(inImage),  
											 CGImageGetHeight(inImage),  
											 CGImageGetBitsPerComponent(inImage),
											 CGImageGetBytesPerRow(inImage),  
											 CGImageGetColorSpace(inImage),  
											 CGImageGetBitmapInfo(inImage) 
											 ); 
	CGContextSetRGBFillColor(ctx, 0,0,0,1);
	CGContextFillRect(ctx, CGRectMake(0, 0, self.size.width, self.size.height));
	imageRef = CGBitmapContextCreateImage(ctx);  
	CGContextRelease(ctx);
	UIImage *blackSquare = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);	
	CFRelease(m_DataRef);	
	UIImage *maskedSquare = [blackSquare mask:mask];
	return [self overlay:[maskedSquare opacity:1.0]];
}

// This filter is not done...
- (UIImage*) polaroidish
{
	NSArray *redPoints = [NSArray arrayWithObjects:
					   [NSValue valueWithCGPoint:CGPointMake(0, 0)],
					   [NSValue valueWithCGPoint:CGPointMake(93, 81)],
					   [NSValue valueWithCGPoint:CGPointMake(247, 241)],
						  [NSValue valueWithCGPoint:CGPointMake(255, 255)],
					   nil];
	NSArray *bluePoints = [NSArray arrayWithObjects:
						  [NSValue valueWithCGPoint:CGPointMake(0, 0)],
						  [NSValue valueWithCGPoint:CGPointMake(57, 59)],
						  [NSValue valueWithCGPoint:CGPointMake(223, 205)],
						  [NSValue valueWithCGPoint:CGPointMake(255, 241)],
						  nil];
	UIImage *image = [[self applyCurve:redPoints toChannel:CurveChannelRed] 
			  applyCurve:bluePoints toChannel:CurveChannelBlue];

	redPoints = [NSArray arrayWithObjects:
						  [NSValue valueWithCGPoint:CGPointMake(0, 0)],
						  [NSValue valueWithCGPoint:CGPointMake(93, 76)],
						  [NSValue valueWithCGPoint:CGPointMake(232, 226)],
						  [NSValue valueWithCGPoint:CGPointMake(255, 255)],
						  nil];
	bluePoints = [NSArray arrayWithObjects:
						   [NSValue valueWithCGPoint:CGPointMake(0, 0)],
						   [NSValue valueWithCGPoint:CGPointMake(57, 59)],
						   [NSValue valueWithCGPoint:CGPointMake(220, 202)],
						   [NSValue valueWithCGPoint:CGPointMake(255, 255)],
						   nil];
	image = [[image applyCurve:redPoints toChannel:CurveChannelRed] 
			 applyCurve:bluePoints toChannel:CurveChannelBlue];
	
	return image;
}


@end
