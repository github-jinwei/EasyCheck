//
//  JWBaseViewController.m
//  EasyCheck
//
//  Created by JinWei on 16/4/22.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "JWBaseViewController.h"
#import "JWRootViewViewController.h"

@interface JWBaseViewController ()

@end

@implementation JWBaseViewController

- (id)init{
    if(self = [super init]){
        self.translucentNavigationBar = NO;
        self.hideNavigationBar        = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view setBackgroundColor:[UIColor colorFromHexString:@"0X1F1F1F"]];
//    
//    if (self.networkInavailableView == nil) {
//        self.networkInavailableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 202, 124)];
//        self.networkInavailableView.backgroundColor = [UIColor clearColor];
//        
//        UIImageView *ivTip = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 202, 124)];
//        ivTip.image = [UIImage imageNamed:@"bad_network_please_check_setting"];
//        
//        [self.networkInavailableView addSubview:ivTip];
//        
//        [self.view addSubview:self.networkInavailableView];
//        self.networkInavailableView.hidden = YES;
//        __weak typeof(self) wSelf = self;
//        [ivTip mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(202, 124));
//            make.centerX.mas_equalTo(wSelf.networkInavailableView.mas_centerX).with.offset(0);
//            make.centerY.mas_equalTo(wSelf.networkInavailableView.mas_centerY).with.offset(50);
//        }];
//    }
}

#pragma mark - 下个页面的返回按钮传空格就是只有一个箭头）。
-(void)baseNextPageTitleButton:(NSString *)nextPageTitleString {
    NSString *titleString = nil;
    if (nextPageTitleString == nil || [nextPageTitleString isEqualToString:@""]) {//传空 ，默认返回。
        titleString = NSLocalizedString(@"返回", nil);
    }else{
        titleString = nextPageTitleString;
    }
    //下一级界面返回按钮
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = titleString;
    temporaryBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
}
#pragma mark - 右上角的按钮传入图片或者文字的字符串、另一个传人nil
-(void)baseRightButtonWithTitle:(NSString *)titleString imageString:(NSString *)imageString {
    UIBarButtonItem *rightTopButton = nil;
    if (titleString) {
        rightTopButton = [[UIBarButtonItem alloc] initWithTitle:titleString style:UIBarButtonItemStylePlain target:self action:@selector(baseRightAction:)];
    }else{
        rightTopButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageString] style:UIBarButtonItemStylePlain target:self action:@selector(baseRightAction:)];
    }
    self.navigationItem.rightBarButtonItem = rightTopButton;
}

#pragma mark - 点击右上角按钮的方法
-(void)baseRightAction:(id)sender{
    
}

/**
 *  导航栏右边按钮
 *
 *  @param name        按钮名称
 *  @param imageString 按钮图片
 *  @param block       返回导航栏右边按钮
 */
- (void)rightButtonWithName:(NSString *)name image:(NSString *)imageString block:(void(^)(UIButton *btn))block{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 100, 44)];
    // 右边按钮  右对齐
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    if (![NSString isEmptyString:imageString]) {
        [button setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageString] forState:UIControlStateHighlighted];
    }
    
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    if (![NSString isEmptyString:name]) {
        [button.titleLabel sizeToFit];
        [button setFrame:CGRectMake(0, 0, button.titleLabel.width, 44)];
    }else{
        [button setFrame:CGRectMake(0, 0, 60, 44)];// 太大的话，影响title
    }
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -5;// 值越大越靠左边
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem];
    
    /// block 回调方法。
    if (block == nil) {
        return;
    }
//    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *btn) {
//        block(button);
//    }];
}

/**
 *  导航栏右边按钮---靠右边的(点击事件小，在titleView太长的时候正好有个按钮和rightBtn太近的时候用的)
 *
 *  @param name        按钮名称
 *  @param imageString 按钮图片
 *  @param block       返回导航栏右边按钮
 */
- (void)rightButtonWithNameRight:(NSString *)name image:(NSString *)imageString block:(void(^)(UIButton *btn))block{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 80, 44)];
    // 右边按钮  右对齐
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    if (![NSString isEmptyString:imageString]) {
        [button setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageString] forState:UIControlStateHighlighted];
    }
    
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    if (![NSString isEmptyString:name]) {
        [button.titleLabel sizeToFit];
        [button setFrame:CGRectMake(0, 0, button.titleLabel.width, 44)];
    }else{
        [button setFrame:CGRectMake(0, 0, 40, 44)];// 太大的话，影响title
    }
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -5;// 值越大越靠左边
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem];
    
    /// block 回调方法。
    if (block == nil) {
        return;
    }
//    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *btn) {
//        block(button);
//    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
