//
//  ImageUtil.h
//  MeiTu
//
//  Created by DBOX on 2017/1/15.
//  Copyright © 2017年 DBOX. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>


@interface ImageUtil : NSObject

+ (CGSize) fitSize: (CGSize)thisSize inSize: (CGSize) aSize;
+ (UIImage *) image: (UIImage *) image fitInSize: (CGSize) viewsize;

+ (UIImage*)blackWhite:(UIImage*)inImage;
+ (UIImage*)cartoon:(UIImage*)inImage;
+ (UIImage*)memory:(UIImage*)inImage;
+ (UIImage*)bopo:(UIImage*)inImage;
+(UIImage*)scanLine:(UIImage*)inImage;

@end
