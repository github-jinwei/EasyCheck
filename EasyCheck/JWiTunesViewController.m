//
//  JWiTunesViewController.m
//  EasyCheck
//
//  Created by jinwei on 16/5/13.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "JWiTunesViewController.h"

@interface JWiTunesViewController(){
    
    UIView * emptyView;
    UITextView * textView;
}

@end

@implementation JWiTunesViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"iTunes添加名单";
    self.view.backgroundColor = [UIColor colorFromHexString:@"d8d8d8" alpha:0.4];
    
    [self initEmptyView];
    
    
}

#pragma mark - 初始化列表为空的ui
- (void)initEmptyView{
    emptyView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    emptyView.backgroundColor = [UIColor whiteColor];
    [emptyView setHidden:NO];
    [self.view addSubview:emptyView];
    
    UIImageView *headLoadFailedImageV = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH / 2) - 35, 80, 70, 70)];
    headLoadFailedImageV.image = [UIImage imageNamed:@"stu_load_failed"];
    [emptyView addSubview:headLoadFailedImageV];
    
    NSString * str = @"把您要添加的名单添加到iTunes中，然后点击即可导入数据。更多信息，请看：设置－>帮助文档";
    //初始化textView
    self.edgesForExtendedLayout = UIRectEdgeNone;
    textView = [[UITextView alloc]  initWithFrame:CGRectMake(20, 150, [UIScreen mainScreen].bounds.size.width - 30, [UIScreen mainScreen].bounds.size.height - 40 - 44 - 20)];
    
    textView.backgroundColor = [UIColor clearColor];
    textView.text = str;
    textView.textColor = [UIColor grayColor];
    
    textView.font = [UIFont systemFontOfSize:18];
    textView.editable = NO;
    [emptyView addSubview:textView];
    
}

@end
