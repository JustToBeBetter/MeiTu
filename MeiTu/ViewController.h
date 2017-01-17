//
//  ViewController.h
//  MeiTu
//
//  Created by DBOX on 2017/1/15.
//  Copyright © 2017年 DBOX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProcessingImageViewDelegate;

@interface ProcessingImageView : UIImageView
{
}
@property (assign) id <ProcessingImageViewDelegate> delegate;

@end

@protocol ProcessingImageViewDelegate
-(void)tapOnCallback:(ProcessingImageView*)imageView;
@end


@interface ViewController : UIViewController
<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ProcessingImageViewDelegate>
{
 
    UIImagePickerController *imagePickerController;
    UIImage *currentImage;
    
    BOOL show;
}

@property (weak, nonatomic) IBOutlet ProcessingImageView *imageV;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segc;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *startItem;
- (IBAction)startEvent:(id)sender;
- (IBAction)saveEvent:(id)sender;
- (IBAction)processingEvent:(id)sender;


@end

