//
//  ProgressHUD.m
//  Vodka
//
//  Created by fusunlang on 14-9-27.
//  Copyright (c) 2014年 Beijing Beast Technology Co.,Ltd. All rights reserved.
//

#import "ProgressHUD.h"
#import "GlobalDefinition.h"

@interface ProgressHUD() {

}

// 是否可以点击背景view，进行事件响应, 默认是打开的
@property (nonatomic, assign) BOOL enableTouchBg;

@end

@implementation ProgressHUD

@synthesize window, hud, spinner, image, label,imageArr;

+ (ProgressHUD *)shared
{
    static dispatch_once_t once = 0;
    static ProgressHUD *progressHUD;
    dispatch_once(&once, ^{
        progressHUD = [[ProgressHUD alloc] init];
        progressHUD.alpha = HUD_ALPHA;
        progressHUD.enableTouchBg = YES;
    });
    return progressHUD;
}

+ (void)dismiss
{
    [[self shared] hudHide];
}

+ (void)show:(NSString *)status wait:(BOOL)wait
{
    [[self shared] hudMake:status imgage:nil spin:wait hide:NO];
}

/**
 *  展示ProgressHud
 *
 *  @param status  <#status description#>
 *  @param wait    <#wait description#>
 *  @param aEnable 背景是否可点击
 */
+ (void)show:(NSString *)status wait:(BOOL)wait enableTouchBg:(BOOL) aEnable {
    [self shared].enableTouchBg = aEnable;
    [[self shared] hudMake:status imgage:nil spin:wait hide:NO];
}

/**
 *  展示ProgressHud
 *
 *  @param status  <#status description#>
 *  @param wait    <#wait description#>
 *  @param aEnable 背景是否可点击
 *  @param delay   延迟消失事件
 */
+ (void)show:(NSString *)status wait:(BOOL)wait enableTouchBg:(BOOL) aEnable delay:(NSTimeInterval)delay {
    [self shared].enableTouchBg = aEnable;
    
    [[self shared] hudMake:status imgage:nil spin:wait delay:delay];
}

+ (void)show:(NSString *)status wait:(BOOL)wait delay:(NSTimeInterval)delay
{
    [[self shared] hudMake:status imgage:nil spin:wait delay:delay];
}

+ (void)showSuccess:(NSString *)status
{
    [[self shared] hudMake:status imgage:HUD_IMAGE_SUCCESS spin:NO hide:YES];
}

+ (void)showSuccess:(NSString *)status delay:(NSTimeInterval)delay
{
    [[self shared] hudMake:status imgage:HUD_IMAGE_SUCCESS spin:NO delay:delay];
}

+ (void)showError:(NSString *)status
{
    [[self shared] hudMake:status imgage:HUD_IMAGE_ERROR spin:NO hide:YES];
}

+ (void)showError:(NSString *)status delay:(NSTimeInterval)delay
{
    [[self shared] hudMake:status imgage:HUD_IMAGE_ERROR spin:NO delay:delay];
}

#pragma mark -  自己加了个延迟dismiss的方法。
+ (void)dismissDelay:(NSTimeInterval)delay {
    if (delay >= 0.0) {
        [[self shared] performSelector:@selector(timedHide) withObject:nil afterDelay:delay];
    }else{
        [[self shared] hudHide];
    }
}

- (id)init
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate respondsToSelector:@selector(window)])
        window = [delegate performSelector:@selector(window)];
    else window = [[UIApplication sharedApplication] keyWindow];
    hud = nil; spinner = nil; image = nil; label = nil;
    self.alpha = 0;
    
    return self;
}

- (void)hudMake:(NSString *)status imgage:(UIImage *)img spin:(BOOL)spin hide:(BOOL)hide
{
    [self hudCreate];
    
    label.text = status;
    label.hidden = (status == nil) ? YES : NO;
    
    //    image.image = img;
    //    image.hidden = (img == nil) ? YES : NO;
    //    if (spin) [spinner startAnimating]; else [spinner stopAnimating];
    //添加自己的动画。todo自己的动画==================================
    if (spin) {
        image.frame = CGRectMake(0, 0, 50, 19);
        [image startAnimating];
    }else{
        [image stopAnimating];
        image.frame = CGRectMake(0, 0, 28, 28);
        image.image = img;
        image.hidden = (img == nil) ? YES : NO;
    }
    //添加自己的动画。todo自己的动画==================================
    
    [self hudOrient];
    [self hudSize];
    [self hudShow];
    
    if (hide) [NSThread detachNewThreadSelector:@selector(timedHide) toTarget:self withObject:nil];
}

- (void)hudMake:(NSString *)status imgage:(UIImage *)img spin:(BOOL)spin delay:(NSTimeInterval)delay
{
    [self hudCreate];
    
    label.text = status;
    label.hidden = (status == nil) ? YES : NO;
    
    //    image.image = img;
    //    image.hidden = (img == nil) ? YES : NO;
    //    if (spin) [spinner startAnimating]; else [spinner stopAnimating];
    //添加自己的动画。todo自己的动画==================================
    if (spin) {
        image.frame = CGRectMake(0, 0, 50, 19);
        [image startAnimating];
    }else{
        [image stopAnimating];
        image.frame = CGRectMake(0, 0, 28, 28);
        image.image = img;
        image.hidden = (img == nil) ? YES : NO;
    }
    //添加自己的动画。todo自己的动画==================================
    
    [self hudOrient];
    if (spin || img ) {
        [self hudSize];
    } else {
        [self hudSizeNoSpin];
    }
    [self hudShow];
    
    if (delay >= 0.0) {
        [self performSelector:@selector(timedHide) withObject:nil afterDelay:delay];
    } else {
        [self performSelector:@selector(timedHide) withObject:nil afterDelay:1.0];
    }
}

- (void)hudCreate {
    if (hud == nil){
        //    [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]
        hud = [[UIToolbar alloc] initWithFrame:CGRectZero];
        hud.barTintColor = HUD_BACKGROUND_COLOR;
        hud.translucent = YES;
        hud.layer.cornerRadius = 10;
        hud.layer.masksToBounds = YES;
        hud.alpha = HUD_ALPHA;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    if (hud.superview == nil) [window addSubview:hud];
    if (spinner == nil){
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.color = HUD_SPINNER_COLOR;
        spinner.hidesWhenStopped = YES;
    }
    if (spinner.superview == nil) [hud addSubview:spinner];
    if (image == nil) {
        //        image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 19)];//todo动画
        
    }
    if (image.superview == nil) [hud addSubview:image];
    
    if (imageArr == nil) {
        imageArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < 14; i++) {
            UIImage* aImage = [UIImage imageNamed:[NSString stringWithFormat:@"pull_refresh_white_%d", i + 1]];
            [imageArr addObject:aImage];
        }
        image.animationRepeatCount = -1;
        image.animationDuration = 0.4;
        [image setAnimationImages:imageArr];
    }
    
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = HUD_STATUS_FONT;
        label.textColor = HUD_STATUS_COLOR;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        label.numberOfLines = 0;
    }
    if (label.superview == nil) [hud addSubview:label];
    
}

- (void)hudDestroy {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [label removeFromSuperview];
    label = nil;
    [image removeFromSuperview];
    image = nil;
    [spinner removeFromSuperview];
    spinner = nil;
    [imageArr removeAllObjects];
    imageArr = nil;
    [hud removeFromSuperview];
    hud = nil;
    
    [self.window setUserInteractionEnabled:YES];
}

- (void)rotate:(NSNotification *)notification {
    [self hudOrient];
}

- (void)hudOrient {
    CGFloat rotate = 0.0;
    UIInterfaceOrientation orient = [[UIApplication sharedApplication] statusBarOrientation];
    if (orient == UIInterfaceOrientationPortrait)			rotate = 0.0;
    ///不应该加下面几个判断，否则就不能适配横屏了。。。。
    //    if (orient == UIInterfaceOrientationPortraitUpsideDown)	rotate = M_PI;
    //    if (orient == UIInterfaceOrientationLandscapeLeft)		rotate = - M_PI_2;
    //    if (orient == UIInterfaceOrientationLandscapeRight)		rotate = + M_PI_2;
    if (!IS_IOS8 && IS_IPHONE4) {
        if (orient == UIInterfaceOrientationPortraitUpsideDown)	rotate = M_PI;
        if (orient == UIInterfaceOrientationLandscapeLeft)		rotate = - M_PI_2;
        if (orient == UIInterfaceOrientationLandscapeRight)		rotate = + M_PI_2;
    }
    
    hud.transform = CGAffineTransformMakeRotation(rotate);
}

- (void)hudSize {
    CGRect labelRect = CGRectZero;
    CGFloat hudWidth = 100, hudHeight = 100;
    
    if (label.text != nil && ![label.text isEqualToString:@""])
    {
        NSDictionary *attributes = @{NSFontAttributeName:label.font};
        NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
        labelRect = [label.text boundingRectWithSize:CGSizeMake(200, 300) options:options attributes:attributes context:NULL];
        
        labelRect.origin.x = 12;
        labelRect.origin.y = 66;
        
        hudWidth = labelRect.size.width + 24;
        hudHeight = labelRect.size.height + 80;
        
        if (hudWidth < 100)
        {
            hudWidth = 100;
            labelRect.origin.x = 0;
            labelRect.size.width = 100;
        }
    }
    else
    {
        hudHeight = 70;
    }
    
    CGSize screen = [UIScreen mainScreen].bounds.size;
    
    hud.center = CGPointMake(screen.width/2, screen.height/2);
    hud.bounds = CGRectMake(0, 0, hudWidth, hudHeight);
    
    CGFloat imagex = hudWidth/2;
    CGFloat imagey = (label.text == nil) ? hudHeight/2 : 36;
    image.center = spinner.center = CGPointMake(imagex, imagey);
    
    label.frame = labelRect;
}

- (void)hudSizeNoSpin
{
    CGRect labelRect = CGRectZero;
    CGFloat hudWidth = 100, hudHeight = 50;
    
    if (label.text != nil)
    {
        NSDictionary *attributes = @{NSFontAttributeName:label.font};
        NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
        labelRect = [label.text boundingRectWithSize:CGSizeMake(200, 300) options:options attributes:attributes context:NULL];
        
        labelRect.origin.x = 12;
        labelRect.origin.y = 12;
        
        hudWidth = labelRect.size.width + 24;
        hudHeight = labelRect.size.height + 24;
        
        if (hudWidth < 100)
        {
            hudWidth = 100;
            labelRect.origin.x = 0;
            labelRect.size.width = 100;
        }
    }
    
    CGSize screen = [UIScreen mainScreen].bounds.size;
    
    hud.center = CGPointMake(screen.width/2, screen.height/2);
    hud.bounds = CGRectMake(0, 0, hudWidth, hudHeight);
    
    CGFloat imagex = hudWidth/2;
    CGFloat imagey = (label.text == nil) ? hudHeight/2 : 36;
    image.center = spinner.center = CGPointMake(imagex, imagey);
    
    label.frame = labelRect;
}

- (void)hudShow
{
    if (self.alpha == 0)
    {
        self.alpha = HUD_ALPHA;
        
        hud.alpha = 0;
        hud.transform = CGAffineTransformScale(hud.transform, 1.4, 1.4);
        
        NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut;
        
        [UIView animateWithDuration:0.15 delay:0 options:options animations:^{
            hud.transform = CGAffineTransformScale(hud.transform, 1/1.4, 1/1.4);
            hud.alpha = HUD_ALPHA;
        } completion:^(BOOL finished){
            [self.window setUserInteractionEnabled:self.enableTouchBg];
        }];
    }
}

- (void)hudHide
{
    if (self.alpha > 0.0)
    {
        NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn;
        
        [UIView animateWithDuration:0.15 delay:0 options:options animations:^{
            hud.transform = CGAffineTransformScale(hud.transform, 0.7, 0.7);
            hud.alpha = 0;
        } completion:^(BOOL finished) {
            [self hudDestroy];
            self.alpha = 0;
        }];
    }
}

- (void)timedHide
{
    @autoreleasepool
    {
        double length = label.text.length;
        NSTimeInterval sleep = length * 0.04 + 0.5;
        
        [NSThread sleepForTimeInterval:sleep];
        [self hudHide];
    }
}



@end
