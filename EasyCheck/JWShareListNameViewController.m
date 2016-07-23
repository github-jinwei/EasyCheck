//
//  JWShareListNameViewController.m
//  EasyCheck
//
//  Created by jinwei on 16/5/16.
//  Copyright © 2016年 Weijin. All rights reserved.
//
#define TableCellHeight     44.0

#import "JWShareListNameViewController.h"
#import "CodeFragments.h"
#import "GlobalDefinition.h"
#import "ClassList.h"
#import "JWListDetailViewController.h"
#import "CoreDataManager.h"
#import "JWAddListViewController.h"
#import "JWShareContentView.h"
#import "JWShareObjectInfo.h"
#import "UIView+Utils.h"
#import "ProgressHUD.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface JWShareListNameViewController()<UITableViewDataSource,UITableViewDelegate,JWShareContentViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *_dataArray; // 数据源数组
    UITableViewCell *_cell;
    JWShareObjectInfo *shareObject;
}

@property (nonatomic, strong)JWShareContentView        *shareContentView;
@property (nonatomic, strong)UIView                    *shareView;
@property (nonatomic, strong)NSArray                   *shareTitlesArray;

@end

@implementation JWShareListNameViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享名单";
    self.view.backgroundColor = [UIColor colorFromHexString:@"d3d2d7" alpha:0.6];
    _dataArray = [NSMutableArray array];
    if (self.view) {
        [self initTableView];
        
        // 分享页面
//        self.shareContentView = [[JWShareContentView alloc] initActivity:YES];
//        self.shareContentView.delegate = self;
//        self.shareContentView.backgroundColor = [UIColor pinkColor];
//        self.shareContentView.titleLabel.text = @"";
//        if (!shareObject) {
//            shareObject = [[JWShareObjectInfo alloc] init];
//        }
//        [self.view addSubview:self.shareContentView];
//        
//        __weak typeof(self) wSelf = self;
//        [self.shareContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(200);
//            make.width.mas_equalTo(SCREEN_WIDTH);
////            make.left.equalTo(wSelf.view.mas_left).with.offset(0);
////            make.right.equalTo(wSelf.view.mas_right).with.offset(0);
//            make.bottom.equalTo(wSelf.view.mas_bottom).with.offset(0);
//        }];
        
//        // 初始化分享控件
        self.shareTitlesArray = @[ @{@"title":NSLocalizedString(@"微信好友", nil), @"imagename":@"share_to_wechat_session"},
                                   @{@"title":NSLocalizedString(@"朋友圈", nil), @"imagename":@"share_to_wechat_timeline"},
                                   @{@"title":NSLocalizedString(@"QQ", nil), @"imagename":@"share_to_qq"},@{@"title":NSLocalizedString(@"新浪微博", nil), @"imagename":@"share_to_sina_weibo"}
                                   ];
        [self initializationShareView];
    }
    
    
                               
}

//初始化table
- (void)initTableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,30,SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorFromHexString:@"d8d8d8" alpha:0.4];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        //[_tableView reloadData];
    }
    
}

-(void)initializationShareView {
    __weak typeof(self) wSelf = self;
    
    self.shareView = [[UIView alloc] init];
    [self.shareView setBackgroundColor:[UIColor colorFromHexString:@"ffffff"]];
    [self.shareView setUserInteractionEnabled:YES];
    [self.view addSubview:self.shareView];
    
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 200));
        make.bottom.equalTo(wSelf.view.mas_bottom).with.offset(200);
        make.left.equalTo(wSelf.view.mas_left).with.offset(0);
        make.right.equalTo(wSelf.view.mas_right).with.offset(0);
    }];
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.backgroundColor = [UIColor clearColor];
    titleL.textColor = [UIColor whiteColor];
    titleL.font = [UIFont systemFontOfSize:14];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text = NSLocalizedString(@"分享给好友", nil) ;
    [self.shareView addSubview:titleL];
    
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.top.equalTo(wSelf.shareView.mas_top).with.offset(15);
        make.centerX.mas_equalTo(wSelf.shareView.mas_centerX).with.offset(0);
    }];
    
    CGFloat scrollViewWidth = SCREEN_WIDTH + 100;
    UIScrollView *shareScrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.shareView.top + 50, scrollViewWidth, 100)];
    shareScrollView.backgroundColor = [UIColor clearColor];
    // 是否滚动
    shareScrollView.scrollEnabled = YES;
    shareScrollView.showsHorizontalScrollIndicator = NO;
    shareScrollView.contentSize = CGSizeMake(scrollViewWidth + 100, 100);
    // 是否同时运动,lock
    shareScrollView.directionalLockEnabled = YES;
    [self.shareView addSubview:shareScrollView];
    
    for (int i = 0; i < self.shareTitlesArray.count; i++) {
        NSDictionary* dict = self.shareTitlesArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setImage:[UIImage imageNamed:dict[@"imagename"]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:dict[@"imagename"]] forState:UIControlStateNormal];
        button.tag = i;
        [shareScrollView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(scrollViewWidth / wSelf.shareTitlesArray.count, 35));
            make.left.equalTo(shareScrollView.mas_left).with.offset((scrollViewWidth * i) / wSelf.shareTitlesArray.count);
            make.centerY.mas_equalTo(wSelf.shareView.mas_centerY).with.offset(0);
        }];
        
        [button addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *nameL = [[UILabel alloc] init];
        nameL.text = dict[@"title"];
        nameL.textColor = [UIColor whiteColor];
        nameL.font = [UIFont systemFontOfSize:12];
        nameL.textAlignment = NSTextAlignmentCenter;
        nameL.backgroundColor = [UIColor clearColor];
        [wSelf.shareView addSubview:nameL];
        
        [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.top.equalTo(button.mas_bottom).with.offset(5);
            make.centerX.mas_equalTo(button.mas_centerX).with.offset(0);
        }];
    }
}

-(void)shareButtonClick:(id)x {
     __weak typeof(self) wSelf = self;
    [wSelf.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(wSelf.view.mas_bottom).with.offset(200);
    }];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [wSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
    UIButton* sender = (UIButton*)x;
    
//    shareObject.title = @"EasyCheck";
//    shareObject.descriptions = @"考勤";
//    shareObject.shareLinkUrl = @"www.baidu.com";
    
    NSString *myShareTitle = @"EasyCheck";//shareObject.title;
    NSString *myShareString = @"考勤";//shareObject.descriptions;
    NSString *myShareUrl = @"www.baidu.com";//shareObject.shareLinkUrl;
    
    if(sender.tag == 0){
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:myShareString
                                         images:nil
                                            url:[NSURL URLWithString:myShareUrl]
                                          title:myShareTitle
                                           type:SSDKContentTypeAuto];
        
        [ShareSDK share:SSDKPlatformTypeWechat parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            
            
        }];
        
    } else if (sender.tag == 1){
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:myShareString
                                         images:nil
                                            url:[NSURL URLWithString:myShareUrl]
                                          title:myShareTitle
                                           type:SSDKContentTypeAuto];
        
        [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            
        }];
        
    } else if (sender.tag == 2){
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:myShareString
                                         images:nil
                                            url:[NSURL URLWithString:myShareUrl]
                                          title:myShareTitle
                                           type:SSDKContentTypeAuto];
        
        [ShareSDK share:SSDKPlatformTypeQQ parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            
        }];
    } else if (sender.tag == 3){// 微博分享
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:myShareString
                                         images:nil
                                            url:[NSURL URLWithString:myShareUrl]
                                          title:myShareTitle
                                           type:SSDKContentTypeAuto];
        //没有这句，直接弹出分享成功了，用户不能输入自己的内容了
        [shareParams SSDKEnableUseClientShare];
        
        
        [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            if (state == SSDKResponseStateSuccess) {
                NSLog(@"分享成功");
                [ProgressHUD showSuccess:NSLocalizedString(@"分享成功", nil)];
            }
            
            for (int i = 0; i < [UIApplication sharedApplication].windows.count; i++) {
                
                if ([[[UIApplication sharedApplication].windows objectAtIndex:i]isKindOfClass:NSClassFromString(@"SSDKWindow")] || [[[UIApplication sharedApplication].windows objectAtIndex:i]isKindOfClass:NSClassFromString(@"UITextEffectsWindow")]){
                    [[UIApplication sharedApplication].windows objectAtIndex:i].frame = CGRectZero;
                    [[[UIApplication sharedApplication].windows objectAtIndex:i]removeFromSuperview];
                    [[UIApplication sharedApplication].windows objectAtIndex:i].layer.masksToBounds = YES;
                }
            }
        }];
    }
}

/**
 *  弹出分享控件
 */
-(void)showShareView{
    //分享
    __weak typeof(self) wSelf = self;
    
    [wSelf.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(wSelf.view.mas_bottom).with.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [wSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark UITableViewDataSource - 代理
#pragma mark - UITableViewDataSource 方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)TableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"listTableCellView";
    _cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (!_cell){
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
        _cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor colorFromHexString:@"d8d8d8" alpha:0.4];
    [_cell.contentView addSubview:view];
    ClassList *p = _dataArray[indexPath.row];
    _cell.textLabel.text = p.classNames;
    return _cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TableCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"你点击了分享");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ClassList *c = _dataArray[indexPath.row];
    
    // 新分享控件
    [self showShareView];
    
//    JWAddListViewController *addListVC = [[JWAddListViewController alloc] init];
//    addListVC.editType = UploadClassList;
//    addListVC.listModel = c;
//    CATransition* transition = [CATransition animation];
//    transition.type = kCATransitionPush;//可更改为其他方式
//    transition.subtype = kCATransitionFromTop;//可更改为其他方式
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    transition.duration = 0.5;
//    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//    [self.navigationController pushViewController:addListVC animated:NO];
    
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath&&_dataArray.count==0) {
        return;
    }
    __weak UITableView *table = tableView;
    __weak ClassList *c = _dataArray[indexPath.row];
    // 设置查询条件 通过用户名 和 id 来约束查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"classNames = %@ and classId = %@",c.classNames,c.classId];
    // 删除之前需要先查询 找了那个对象才能执行删除的操作
    [CoreDataManager executeFetchRequest:[ClassList class] predicate:predicate complete:^(NSArray *array, NSError *error) {
        if (array && array.count>0) {
            // 取出结果数组里的模型 并删除 然后保存上下文
            for (ClassList *c in array) {
                [CoreDataManager deleteObject:c];
            }
            NSError *error = nil;
            // 保存上下文就存储数据
            [CoreDataManager save:&error];
            if (!error) {
                [_dataArray removeObject:c];
            }
            //移除tableView中的数据
            [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 1;
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadDatas];
}


/**
 *   从数据库读取数据
 */
- (void)loadDatas
{
    // 获取所有班级列表
    [CoreDataManager executeFetchRequest:[ClassList class] predicate:nil complete:^(NSArray *array, NSError *error)
     {
         [_dataArray removeAllObjects];
         if (array && array.count>0) {
             for (ClassList *c in array) {
                 [_dataArray addObject:c];
             }
             [_tableView reloadData];
         }
     }];
}

@end
