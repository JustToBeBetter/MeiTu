//
//  ViewController.m
//  MeiTu
//
//  Created by DBOX on 2017/1/15.
//  Copyright © 2017年 DBOX. All rights reserved.
//

#import "ViewController.h"
#import "ImageUtil.h"
#import "DWBubbleMenuButton.h"
#import "BSAutoImageFilter.h"
#import <GPUImage/GPUImage.h>


@implementation ProcessingImageView
@synthesize delegate;

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([(NSObject*)delegate respondsToSelector:@selector(tapOnCallback:)])
    {
        [delegate tapOnCallback:self];
    }
}
@end


@interface ViewController ()<BSAutoImageFilterDelegate>

@property (nonatomic , strong) DWBubbleMenuButton *animationMenu;
@property (nonatomic, strong) BSAutoImageFilter *autoImageFilter;
@property (nonatomic, strong) GPUImagePicture *originPicture;




@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
    self.imageV.delegate = self;
    self.imageV.userInteractionEnabled = YES;
    show = YES;
    
    [self createMeauView];
}
- (void)createMeauView{
    UILabel *homeLabel = [self createHomeButtonView];
    
    DWBubbleMenuButton *upMenuView = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - homeLabel.frame.size.width - 20.f,
                                                                                          self.view.frame.size.height - homeLabel.frame.size.height - 60.f,
                                                                                          homeLabel.frame.size.width,
                                                                                          homeLabel.frame.size.height)
                                                            expansionDirection:DirectionUp];
    upMenuView.homeButtonView = homeLabel;
    [upMenuView addButtons:[self createDemoButtonArray]];
    
    _animationMenu = upMenuView;
    if (show) {
        _animationMenu.hidden = NO;
    }else{
        _animationMenu.hidden = YES;
        
    }
    
    [self.view addSubview:upMenuView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)snap:(id)sender
{
    if(imagePickerController)
    {
        [imagePickerController takePicture];
    }
}

-(void)close:(id)sender
{
    if(imagePickerController)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark -
-(void)tapOnCallback:(ProcessingImageView*)imageView
{
  
    [UIView beginAnimations:@"aa" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    
    [[UIApplication sharedApplication] setStatusBarHidden:show animated:NO];
    if(show)
    {
        self.toolbar.alpha = 0.0;
        self.navigationController.navigationBar.alpha = 0.0;
    }
    else
    {
        self.toolbar.alpha = 1.0;
         self.navigationController.navigationBar.alpha = 1.0;
    }
    [UIView commitAnimations];
    show = !show;
    if (show) {
        _animationMenu.hidden = NO;
    }else{
        _animationMenu.hidden = YES;
        
    }
}

#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if(buttonIndex == 0)
        {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentModalViewController:imagePickerController animated:YES];
        }
        if(buttonIndex == 1)
        {
            UIView *cameraView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
            cameraView.backgroundColor = [UIColor clearColor];
            cameraView.autoresizesSubviews = YES;
            
            UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, cameraView.frame.size.height-53.0, cameraView.frame.size.width, 53.0)];
            bottomBar.backgroundColor = [UIColor whiteColor];
            bottomBar.autoresizesSubviews = YES;
            
            UIButton *snapBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [snapBtn setTitle:@"拍照" forState:UIControlStateNormal];
            snapBtn.frame = CGRectMake(5.0, 9.0, 60.0, 33.0);
            [snapBtn addTarget:self action:@selector(snap:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
            closeBtn.frame = CGRectMake(bottomBar.frame.size.width-60.0-5.0, 9.0, 60.0, 33.0);
            [closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
            
            [bottomBar addSubview:snapBtn];
            [bottomBar addSubview:closeBtn];
            
            [cameraView addSubview:bottomBar];
            
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.showsCameraControls = NO;
            imagePickerController.cameraOverlayView = cameraView;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
    else
    {
        if(buttonIndex == 0)
        {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
}

#pragma mark -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSLog(@"found an image");
        
        UIImage *resizedImg = [ImageUtil image:image fitInSize:CGSizeMake(320.0, 480.0)];
        self.imageV.image = resizedImg;
        currentImage = resizedImg;
    }
    //picker.cameraViewTransform = CGAffineTransformIdentity;
    [self.segc setSelectedSegmentIndex:0];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) image: (UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo;
{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:nil message:@"已保存到相册" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [al show];
    self.saveItem.enabled = YES;
}
- (IBAction)startEvent:(id)sender {
    UIActionSheet *ac = nil;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        ac = [[UIActionSheet alloc] initWithTitle:@"照片来源"
                                         delegate:self
                                cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                                otherButtonTitles:@"相册",@"拍照",nil];
    }
    else
    {
        ac = [[UIActionSheet alloc] initWithTitle:@"照片来源"
                                         delegate:self
                                cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                                otherButtonTitles:@"相册",nil];
    }
    ac.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [ac showInView:self.view];

}

- (IBAction)saveEvent:(id)sender {
    
    if(self.imageV.image)
    {
        self.saveItem.enabled = NO;
        UIImageWriteToSavedPhotosAlbum(self.imageV.image, self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);
    }
}

- (IBAction)processingEvent:(id)sender {
    UISegmentedControl *sg = (UISegmentedControl*)sender;
    if(currentImage)
    {
        UIImage *outImage = nil;
        if(sg.selectedSegmentIndex == 0)
        {
            self.imageV.image = currentImage;
        }
        
        if(sg.selectedSegmentIndex == 1)
        {
            outImage = [ImageUtil blackWhite:currentImage];
        }
        if(sg.selectedSegmentIndex == 2)
        {
            outImage = [ImageUtil cartoon:currentImage];
        }
        if(sg.selectedSegmentIndex == 3)
        {
            outImage = [ImageUtil bopo:currentImage];
        }
        if(sg.selectedSegmentIndex == 4)
        {
            outImage = [ImageUtil memory:currentImage];
        }
        if(sg.selectedSegmentIndex == 5)
        {
            outImage = [ImageUtil scanLine:currentImage];
        }
        if(outImage)
        {
            self.imageV.image = outImage;
        }
    }

}

#pragma
#pragma  mark =================更多选项=================

- (UILabel *)createHomeButtonView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 100.f, 40.f)];
    
    label.text = @"Tap";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = label.frame.size.height / 2.f;
    label.backgroundColor =[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
    label.clipsToBounds = YES;
    
    return label;
}
- (NSArray *)createDemoButtonArray {
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (NSString *title in @[@"一键美化", @"晕映", @"模糊", @"膨胀扭曲", @"闭运算", @"开运算", @"颜色反转"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        
        button.frame = CGRectMake(0.f, 0.f, 120.f, 30.f);
        button.layer.cornerRadius = button.frame.size.height / 2.f;
        button.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
        button.clipsToBounds = YES;
        button.tag = i++;
        
        [button addTarget:self action:@selector(dwBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonsMutable addObject:button];
    }
    
    return [buttonsMutable copy];
}

- (void)dwBtnClick:(UIButton *)sender {
    NSLog(@"DWButton tapped, tag: %ld", (long)sender.tag);
    switch (sender.tag) {
        case 0://一键美化
        {
                [self.autoImageFilter autoFiltWithImage:currentImage];
        }
            break;
        case 1://晕映 GPUImageVignetteFilter
        {
            [self processingImageWithFiterName:@"GPUImageVignetteFilter"];
            
        }
            break;
        case 2://模糊 GPUImageiOSBlurFilter
        {
            [self processingImageWithFiterName:@"GPUImageiOSBlurFilter"];
        }
            break;
        case 3://膨胀扭曲 GPUImageBulgeDistortionFilter
        {
            [self processingImageWithFiterName:@"GPUImageBulgeDistortionFilter"];
        }
            break;
        case 4://闭运算 GPUImageClosingFilter
        {
            [self processingImageWithFiterName:@"GPUImageClosingFilter"];
        }
            break;
        case 5://开运算 GPUImageOpeningFilter
        {
            [self processingImageWithFiterName:@"GPUImageOpeningFilter"];
        }
            break;
        case 6://颜色反转 GPUImageColorInvertFilter
        {
            [self processingImageWithFiterName:@"GPUImageColorInvertFilter"];
        }
            break;
        default:
            break;
    }
    
    
}


#pragma
#pragma  mark =================imageProcess=================
- (void)processingImageWithFiterName:(NSString *)filterName{
    
    if (currentImage) {
        GPUImageFilter *filter = [[NSClassFromString(filterName) alloc] init];
        self.originPicture = [[GPUImagePicture alloc]initWithImage:currentImage];
        [self.originPicture addTarget:filter];
        [filter useNextFrameForImageCapture];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.originPicture processImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self processFinishedWithFilter:filter];
            });
        });
        
    }

}
- (BSAutoImageFilter *)autoImageFilter
{
    if (_autoImageFilter == nil) {
        _autoImageFilter = [[BSAutoImageFilter alloc] init];
        _autoImageFilter.delegate = self;
    }
    return _autoImageFilter;
}

- (void)processFinishedWithFilter:(GPUImageFilter *)filter
{
    self.imageV.image = [filter imageFromCurrentFramebuffer];
}
@end
