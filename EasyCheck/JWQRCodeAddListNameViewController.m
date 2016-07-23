//
//  JWQRCodeAddListNameViewController.m
//  EasyCheck
//
//  Created by jinwei on 16/5/15.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "JWQRCodeAddListNameViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CodeFragments.h"
#import "GlobalDefinition.h"

@interface JWQRCodeAddListNameViewController() <AVCaptureMetadataOutputObjectsDelegate>{
    //二维码
    int line_tag;
    UIView *scanView;
    
}

//二维码相关
@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) AVCaptureDeviceInput *input;
@property (strong, nonatomic) AVCaptureMetadataOutput *output;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation JWQRCodeAddListNameViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"扫描二维码";
    self.view.backgroundColor = [UIColor colorFromHexString:@"d8d8d8" alpha:0.4];
    
    [self initWithQRCodeAddClassInfo];
    
    
}

- (void)initWithQRCodeAddClassInfo {
    //扫描view
    scanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scanView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:scanView];
    
    line_tag = 1872637;
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    _session = [[AVCaptureSession alloc] init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        [_session addInput:input];
    }
    if (output) {
        [_session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *a = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        output.metadataObjectTypes=a;
    }
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    self.previewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame=scanView.layer.bounds;
    [scanView.layer addSublayer:self.previewLayer];
    
    [self setOverlayPickerView];
    
    [_session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:nil];
    
    //开始捕获
    [_session startRunning];
}

#pragma mark --
#pragma mark - 二维码扫描签到代理
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    NSString *objectId;
    if (metadataObjects != nil && [metadataObjects count] > 0){
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        
        if ([[metadataObject type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            objectId = metadataObject.stringValue;
            //            [ClubActivityRequestManager ClubActivitySignInWithObjectId:objectId ActivityId:self.model.actId completion:^(BOOL successed, NSInteger code, NSString *responseString) {
            //                if (successed) {
            //                    self.registCountLabel.text = [NSString stringWithFormat:@"(%@/%@)",responseString,self.model.members];
            //                    ClubActivityListViewController *clubActivityListVC = [[ClubActivityListViewController alloc] init];
            //                    clubActivityListVC.isSign = YES;
            //                    [ProgressHUD showSuccess:NSLocalizedString(@"签到成功", nil) delay:1.0f];
            //                } else {
            //                    [ProgressHUD showError:responseString delay:1.0f];
            //                }
            //            }];
            
            //停止扫描
            [_session stopRunning];
            _session = nil;
            [self selfRemoveFromSuperview];
        }
    }
}

#pragma  mark -监听扫码状态-修改扫描动画
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([object isKindOfClass:[AVCaptureSession class]]) {
        BOOL isRunning = ((AVCaptureSession *)object).isRunning;
        if (isRunning) {
            [self addAnimation];
        } else {
            [self removeAnimation];
        }
    }
}

#pragma  mark -添加扫码动画
- (void)addAnimation{
    UIView *line = [self.view viewWithTag:line_tag];
    line.hidden = NO;
    CABasicAnimation *animation = [JWQRCodeAddListNameViewController moveYTime:2 fromY:[NSNumber numberWithFloat:0] toY:[NSNumber numberWithFloat:SCREEN_WIDTH-60-2] rep:OPEN_MAX];
    [line.layer addAnimation:animation forKey:@"LineAnimation"];
}

#pragma  mark -去除扫码动画
- (void)removeAnimation {
    UIView *line = [self.view viewWithTag:line_tag];
    [line.layer removeAnimationForKey:@"LineAnimation"];
    line.hidden = YES;
}

#pragma  mark -扫码动画时间设定
+ (CABasicAnimation *)moveYTime:(float)time fromY:(NSNumber *)fromY toY:(NSNumber *)toY rep:(int)rep
{
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:fromY];
    [animationMove setToValue:toY];
    animationMove.duration = time;
    animationMove.delegate = self;
    animationMove.repeatCount  = rep;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.removedOnCompletion = NO;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animationMove;
}

#pragma  mark -创建扫码页面
- (void)setOverlayPickerView
{
    //左侧的view
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, SCREEN_HEIGHT)];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [scanView addSubview:leftView];
    //右侧的view
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 0, 30, SCREEN_HEIGHT)];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [scanView addSubview:rightView];
    
    //最上部view
    UIImageView* upView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 60, (self.view.center.y - ( SCREEN_WIDTH - 60 ) / 2) +1 )];
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [scanView addSubview:upView];
    
    //底部view
    UIImageView * downView = [[UIImageView alloc] initWithFrame:CGRectMake(30, (self.view.center.y + (SCREEN_WIDTH - 60) / 2) - 1, (SCREEN_WIDTH - 60), (SCREEN_HEIGHT - (self.view.center.y -(SCREEN_WIDTH - 60) / 2)))];
    downView.alpha = 0.5;
    downView.backgroundColor = [UIColor blackColor];
    [scanView addSubview:downView];
    
    UIImageView *centerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, SCREEN_WIDTH - 60)];
    centerView.center = self.view.center;
    centerView.image = [UIImage imageNamed:@"scan_qrcode_image"];
    centerView.contentMode = UIViewContentModeScaleAspectFit;
    centerView.backgroundColor = [UIColor clearColor];
    [scanView addSubview:centerView];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(upView.frame), SCREEN_WIDTH - 60, 2)];
    line.tag = line_tag;
    line.image = [UIImage imageNamed:@"scan_qrcode_line_image"];
    line.contentMode = UIViewContentModeScaleAspectFill;
    line.backgroundColor = [UIColor clearColor];
    [scanView addSubview:line];
    
}

#pragma  mark -从父视图中移出
- (void)selfRemoveFromSuperview {
    [_session removeObserver:self forKeyPath:@"running" context:nil];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        scanView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.previewLayer removeFromSuperlayer];
        [scanView removeFromSuperview];
    }];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self preferredStatusBarStyle];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //停止扫描
    [_session stopRunning];
    _session = nil;
    
    [self.previewLayer removeFromSuperlayer];
    [scanView removeFromSuperview];
}

@end
