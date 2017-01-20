//
//  ImageAnalyzer.h
//  GPUImageDemo
//
//  Created by casa on 4/3/15.
//  Copyright (c) 2015 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString * const IABrightness = @"brightness";
static NSString * const IASaturation = @"saturation";
static NSString * const IATemperature = @"temperature";

@interface ImageAnalyzer : NSObject

- (NSDictionary *)analyzeImage:(UIImage *)image;

@end
