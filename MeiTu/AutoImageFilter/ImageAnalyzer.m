//
//  ImageAnalyzer.m
//  GPUImageDemo
//
//  Created by casa on 4/3/15.
//  Copyright (c) 2015 alibaba. All rights reserved.
//

#import "ImageAnalyzer.h"

#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )

@implementation ImageAnalyzer
- (NSDictionary *)analyzeImage:(UIImage *)image
{
    CGImageRef inputCGImage = [[self generatePhotoThumbnail:image] CGImage];
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    UInt32 * pixels;
    pixels = (UInt32 *) calloc(height * width, sizeof(UInt32));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    NSInteger saturationList[101];
    memset(saturationList, 0, sizeof(NSInteger) * 101);
    NSInteger brightnessList[51];
    memset(brightnessList, 0, sizeof(NSInteger) * 51);
    
    NSInteger index = 0;
    
    CGFloat totalRed = 0;
    CGFloat totalBlue = 0;
    
    UInt32 * currentPixel = pixels;
    for (NSUInteger j = 0; j < height; j++) {
        for (NSUInteger i = 0; i < width; i++) {
            UInt32 color = *currentPixel;
            CGFloat hue, saturation, brightness;
            CGFloat red = R(color), green = G(color), blue = B(color);
            [self red:red green:green blue:blue ToHue:&hue saturate:&saturation value:&brightness];
            
            totalRed += red;
            totalBlue += blue;
            index = (NSInteger)(saturation * 100);
            saturationList[index]++;
            index = brightness / 5;
            brightnessList[index]++;
            
            currentPixel++;
        }
    }
    
    free(pixels);
    
    // saturation
    CGFloat totalSum = 0;
    for (int i = 0; i < 101; i++) {
        totalSum += saturationList[i];
    }
    
    CGFloat totalSaturation = 0;
    for (int i = 0; i < 101; i++) {
        CGFloat rate = (CGFloat)(saturationList[i]) / totalSum;
        totalSaturation += (i * rate);
    }
    
    // brightness
    totalSum = 0;
    for (int i = 0; i < 51; i++) {
        totalSum += brightnessList[i];
    }
    
    CGFloat totalBrightness = 0;
    for (int i = 0; i < 51; i++) {
        CGFloat rate = (CGFloat)(brightnessList[i]) / totalSum;
        totalBrightness += (i * 5 * rate);
    }
    
    CGFloat temperature = totalRed / totalBlue * 10000;
    
    return @{
             @"brightness":@(totalBrightness),
             @"temperature":@(temperature),
             @"saturation":@(totalSaturation)
             };
}

#pragma mark - private method
- (UIImage *)generatePhotoThumbnail:(UIImage *)image
{
    // Create a thumbnail version of the image for the event object.
    CGSize size = image.size;
    CGSize croppedSize;
    CGFloat ratio = 300.0;
    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;
    
    // check the size of the image, we want to make it
    // a square with sides the size of the smallest dimension
    if (size.width > size.height) {
        offsetX = (size.height - size.width) / 2;
        croppedSize = CGSizeMake(size.height, size.height);
    } else {
        offsetY = (size.width - size.height) / 2;
        croppedSize = CGSizeMake(size.width, size.width);
    }
    
    // Crop the image before resize
    CGRect clippedRect = CGRectMake(offsetX * -1, offsetY * -1, croppedSize.width, croppedSize.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    // Done cropping
    
    // Resize the image
    CGRect rect = CGRectMake(0.0, 0.0, ratio, ratio);
    
    UIGraphicsBeginImageContext(rect.size);
    [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Done Resizing
    
    return thumbnail;
}

- (void)red:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b ToHue:(CGFloat *)h saturate:(CGFloat *)s value:(CGFloat *)v
{
    float min, max, delta;
    min = [self minValueWithArray:@[@(r), @(g), @(b)]];
    max = [self maxValueWithArray:@[@(r), @(g), @(b)]];
    *v = max;       // v
    delta = max - min;
    if( max != 0 )
        *s = delta / max;		// s
    else {
        // r = g = b = 0		// s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;		// between yellow & magenta
    else if( g == max )
        *h = 2 + ( b - r ) / delta;	// between cyan & yellow
    else
        *h = 4 + ( r - g ) / delta;	// between magenta & cyan
    *h *= 60;				// degrees
    if( *h < 0 )
        *h += 360;
}

- (CGFloat)minValueWithArray:(NSArray *)array
{
    __block CGFloat minValue = CGFLOAT_MAX;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat objValue = [obj floatValue];
        if (objValue < minValue) {
            minValue = objValue;
        }
    }];
    return minValue;
}

- (CGFloat)maxValueWithArray:(NSArray *)array
{
    __block CGFloat maxValue = CGFLOAT_MIN;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat objValue = [obj floatValue];
        if (objValue > maxValue) {
            maxValue = objValue;
        }
    }];
    return maxValue;
}

@end
