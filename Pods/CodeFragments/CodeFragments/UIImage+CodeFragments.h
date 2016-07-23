//
//  UIImage+CodeFragments.h
//  CodeFragment
//
//  Created by jinyu on 15/2/4.
//  Copyright (c) 2015年 jinyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CodeFragments)

/**
 *  @brief 生成圆角图片
 *
 *  @param image 要生成圆角的图片
 *  @param size  生成的图片大小
 *  @param r     圆角的大小
 *
 *  @return      生成的圆角图片
 */
+ (UIImage*)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

+ (UIImage*)scaleToSize:(CGSize)size image:(UIImage*)image;

/**
 *  @brief 生成截图
 *
 *  @param view  要截图的view
 *  @param size  要截取view上边图片的大小
 *
 *  @return      生成的截图
 */

+ (UIImage*)screenShot:(UIView *)view size:(CGSize)size resultImage:(void (^)(UIImage* image))resultImage;

//获取图片中某一点的颜色值

- (UIColor *)colorAtPixel:(CGPoint)point;



- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;



@end

