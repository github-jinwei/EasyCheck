//
//  JWLockView.h
//  EasyCheck
//
//  Created by jinwei on 16/5/17.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, passwordtype){
    ResetPassWordType = 1,
    UsePassWordType = 2,
};

@class JWLockView;
@protocol JWLockViewDelegate <NSObject>

@optional
- (BOOL)unlockView:(JWLockView *)unlockView withPassword:(NSString *)password;

- (void)setPassWordSuccess:(NSString *)tabelname;

@end

@interface JWLockView : UIView

@property (nonatomic, weak) id<JWLockViewDelegate> delegate;

@end
