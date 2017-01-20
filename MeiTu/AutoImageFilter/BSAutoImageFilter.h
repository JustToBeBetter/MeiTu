//
//  BSAutoImageFilter.h
//  GPUImageDemo
//
//  Created by casa on 4/21/15.
//  Copyright (c) 2015 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BSAutoImageFilter;

@protocol BSAutoImageFilterDelegate <NSObject>

- (void)autoImageFilter:(BSAutoImageFilter *)autoImageFilter didFinishedWithOriginImage:(UIImage *)originImage processedImage:(UIImage *)processedImage;

@end

@interface BSAutoImageFilter : NSObject

@property (nonatomic, weak) id<BSAutoImageFilterDelegate> delegate;
- (void)autoFiltWithImage:(UIImage *)image;

@end
