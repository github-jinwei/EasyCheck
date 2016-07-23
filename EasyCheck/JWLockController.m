//
//  JWLockController.m
//  EasyCheck
//
//  Created by jinwei on 16/5/17.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "JWLockController.h"
#import "JWLockView.h"
#import "UIView+Extension.h"
#import "GlobalDefinition.h"

@interface JWLockController ()<JWLockViewDelegate>

@property(nonatomic,weak)UILabel *unlocklabel;
@property(nonatomic,weak)UILabel *setpassword;


//判断是否是两次确认密码
@property(nonatomic,assign,getter=istwopassword)BOOL twopassword;

@property(strong,nonatomic)JWLockView *lockview;

@end

@implementation JWLockController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.resetpassword = NO;
    self.twopassword = NO;
    self.lockview = [[JWLockView alloc] init];
    self.lockview.backgroundColor = [UIColor clearColor];
    self.lockview.width = 300;
    self.lockview.height = 300;
    self.lockview.x = (SCREEN_WIDTH - self.lockview.width) * 2 + 40;
    self.lockview.y = 150 * 2;
    self.lockview.delegate = self;
    
    [self.view addSubview:self.lockview];
    self.view.backgroundColor = [UIColor colorFromHexString:@"32caba" alpha:1];
    
    [self judgeMentLocalPassWord];
}

//设置状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

////添加重置密码按钮
//- (void)addResetPassWordBuutton{
//    UIButton *resetpassword = [[UIButton alloc]init];
//    [resetpassword setTitle:@"修改密码" forState:UIControlStateNormal];
//    [resetpassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [resetpassword sizeToFit];
//    resetpassword.y = CGRectGetMaxY(self.lockview.frame) + 50;
//    resetpassword.x = (SCREEN_WIDTH - resetpassword.width) * 0.5;
//    [self.view addSubview:resetpassword];
//    [resetpassword addTarget:self action:@selector(resetPassWord) forControlEvents:UIControlEventTouchUpInside];
//    
//}

//添加下次设置按钮
- (void)addCancelButton{
    UIButton *cancelbutt = [[UIButton alloc]init];
    [cancelbutt setTitle:@"下次设置" forState:UIControlStateNormal];
    [cancelbutt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelbutt sizeToFit];
    cancelbutt.y = CGRectGetMaxY(self.lockview.frame) + 50;
    cancelbutt.x = (SCREEN_WIDTH - cancelbutt.width) * 0.5;
    [self.view addSubview:cancelbutt];
    [cancelbutt addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}

//添加重置密码和取消设置的按钮
//- (void)addResetPassWordButtAndCancelButt{
//
//    UIButton *resetpassword = [[UIButton alloc]init];
//    [resetpassword setTitle:@"重置密码" forState:UIControlStateNormal];
//    [resetpassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [resetpassword sizeToFit];
//    resetpassword.y = 500;
//    resetpassword.x = 80;
//    [self.view addSubview:resetpassword];
//    [resetpassword addTarget:self action:@selector(resetPassWord) forControlEvents:UIControlEventTouchUpInside];
//
//
//    UIButton *cancelbutt = [[UIButton alloc]init];
//    [cancelbutt setTitle:@"下次设置" forState:UIControlStateNormal];
//    [cancelbutt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [cancelbutt sizeToFit];
//    cancelbutt.y = 500;
//    cancelbutt.x = CGRectGetMaxX(resetpassword.frame) + 50;
//    [self.view addSubview:cancelbutt];
//    [cancelbutt addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
//
//}

//取消设置按钮
- (void)cancelButtonClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//重置按钮点击事件
- (void)resetPassWord{
    [self setLocklabel:@"确认旧手势密码"];
    [self.unlocklabel sizeToFit];
    self.unlocklabel.x = (SCREEN_WIDTH - self.unlocklabel.width) * 0.5 + 80;
    self.unlocklabel.y = CGRectGetMinY(self.lockview.frame) - 40;
    
}

#pragma mark -  lockview的代理方法
- (BOOL)unlockView:(JWLockView *)unlockView withPassword:(NSString *)password
{
    NSString *localpasswordone = [[NSUserDefaults standardUserDefaults]objectForKey:@"passwordone"];
    NSString *localpasswordtwo = [[NSUserDefaults standardUserDefaults]objectForKey:@"passwordtwo"];
    
    if (self.twopassword) {
        if ([localpasswordone isEqualToString:localpasswordtwo]) {
            UIAlertView *confirmalertview = [[UIAlertView alloc]initWithTitle:@"密码设置成功" message:@"请输入密码解锁" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [confirmalertview show];
            [self setLocklabel:@"手势解锁"];
            self.twopassword = NO;
            return YES;
        }
        
        else
        {
            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"与上次密码不对应" message:@"请重新设置密码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alertview show];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"passwordone"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"passwordtwo"];
            [self setLocklabel:@"设置密码"];
            return NO;
        }
    }
    
    else
        
    {
        if ([password isEqualToString:localpasswordone]) {
            if (self.isresetpassword) {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"passwordone"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"passwordtwo"];
                [self setLocklabel:@"设置新密码"];
                UIAlertView *resetalertview = [[UIAlertView alloc]initWithTitle:@"密码确认成功" message:@"请重新设置密码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [resetalertview show];
                self.resetpassword = NO;
            }
            else
            {
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
            return YES;
        }
        else {
            return NO;
        }
        return NO;
    }
}

- (void)setPassWordSuccess:(NSString *)tabelname{
    NSString *localpasswordone = [[NSUserDefaults standardUserDefaults]objectForKey:@"passwordone"];
    NSString *localpasswordtwo = [[NSUserDefaults standardUserDefaults]objectForKey:@"passwordywo"];
    if (!localpasswordtwo||!localpasswordone ) {
        self.twopassword = YES;
    }
    self.setpassword.text = tabelname;
    self.unlocklabel.text = tabelname;
    [self.unlocklabel sizeToFit];
    [self.setpassword sizeToFit];
    self.setpassword.x = (SCREEN_WIDTH - self.setpassword.width) * 0.5;
    self.setpassword.y = CGRectGetMinY(self.lockview.frame) - 40;
    self.unlocklabel.x = (SCREEN_WIDTH - self.unlocklabel.width) * 0.5;
    self.unlocklabel.y = CGRectGetMinY(self.lockview.frame) - 40;
    
}

//判断本地是否存有密码
- (void)judgeMentLocalPassWord{
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"passwordone"];
    if (password == nil) {
        //添加下次设置按钮
        [self addCancelButton];
        [self setPassWordView:@"设置手势密码"];
    } else {
        //添加重置密码按钮
        //[self addResetPassWordBuutton];
        if (self.resetpassword) {
            //[self resetPassWord];
            [self unlockView:@"手势解锁"];
            [self setLocklabel:@"确认旧手势密码"];
            [self.unlocklabel sizeToFit];
            self.unlocklabel.x = (SCREEN_WIDTH - self.unlocklabel.width) * 0.5 + 80;
            self.unlocklabel.y = CGRectGetMinY(self.lockview.frame) - 40;
        } else {
             [self unlockView:@"手势解锁"];
        }
    }
    
}

//设置密码界面
- (void)setPassWordView:(NSString *)lockstr{
    UILabel *locklabel = [[UILabel alloc]init];
    locklabel.text = lockstr;
    locklabel.textAlignment = NSTextAlignmentCenter;
    self.setpassword = locklabel;
    locklabel.textColor = [UIColor whiteColor];
    [locklabel sizeToFit];
    locklabel.x = (SCREEN_WIDTH - locklabel.width) * 0.5;
    locklabel.y = CGRectGetMinY(self.lockview.frame) - 40;
    [self.view addSubview:locklabel];
}

- (void)setLocklabel:(NSString *)locklstr{
    
    self.setpassword.text = locklstr;
    self.unlocklabel.text = locklstr;
    [self.setpassword sizeToFit];
    [self.unlocklabel sizeToFit];
    self.setpassword.x = (SCREEN_WIDTH - self.setpassword.width) * 0.5;
    self.setpassword.y = CGRectGetMinY(self.setpassword.frame) - 40;
    self.unlocklabel.x = (SCREEN_WIDTH - self.unlocklabel.width) * 0.5;
    self.unlocklabel.y = CGRectGetMinY(self.lockview.frame) - 40;
    [self.view addSubview:self.setpassword];
    [self.view addSubview:self.unlocklabel];
    
}

//手势解锁界面
- (void)unlockView:(NSString *)unlockstr{
    UILabel *locklabel = [[UILabel alloc]init];
    self.unlocklabel = locklabel;
    locklabel.text = unlockstr;
    locklabel.textColor = [UIColor whiteColor];
    [locklabel sizeToFit];
    locklabel.x = (SCREEN_WIDTH - locklabel.width) * 0.5;
    locklabel.y = CGRectGetMinY(self.lockview.frame) - 40;
    [self.view addSubview:locklabel];
}


@end
