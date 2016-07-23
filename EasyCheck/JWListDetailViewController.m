//
//  JWListDetailViewController.m
//  EasyCheck
//
//  Created by JinWei on 16/5/8.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "JWListDetailViewController.h"
#import "ListDetailTableViewCell.h"
#import "GlobalDefinition.h"
#import "StudentModel.h"
#import "CoreDataManager.h"
#import "JWRightAlertListView.h"
#import "JWiTunesViewController.h"
#import "JWBatchAddStudentInfoViewController.h"
#import "JWManualAddStudentInfoViewController.h"
#import "UIView+Utils.h"
#import "ChineseString.h"
#import "HistoryModel.h"
#import "HistoryDetailModel.h"
#import "StatisticsModel.h"
#import "ProgressHUD.h"
#import "JWRandomViewController.h"
#import <AVFoundation/AVFoundation.h>

#define TableCellHeight     60.0

@interface JWListDetailViewController()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,JWRightAlertListViewDelegate,AVCaptureMetadataOutputObjectsDelegate>{
    UITableView *_tableView;
    UIView * emptyView;
    UIView *footView;
    UITextView * textView;
    NSArray *dataArr; //添加学生信息方式选项列表
    JWRightAlertListView *rightAlertListV;
    
    //二维码
    int line_tag;
    UIView *scanView;
    
    int attendanceStatus;

}

@property (strong, nonatomic) ListDetailTableViewCell *cell;
@property (strong, nonatomic) HistoryDetailModel *hisDetailAddInfo;
@property (strong, nonatomic) NSMutableArray *allStuInfo;
@property (strong, nonatomic) NSMutableArray *stuIdArray;      // 数据源stuId

//二维码相关
@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) AVCaptureDeviceInput *input;
@property (strong, nonatomic) AVCaptureMetadataOutput *output;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

//分组相关
@property (strong, nonatomic) NSMutableArray *indexArray;
@property (strong, nonatomic) NSMutableArray *letterResultArr;
@property (strong, nonatomic) NSMutableArray *dataArray;      // 数据源数组
@property (strong, nonatomic) NSMutableArray *hisDetailArray; // 历史数组
@property (strong, nonatomic) NSMutableArray *stringsToSort;
@property (strong, nonatomic) ChineseString  *chineseString;

@end

@implementation JWListDetailViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"名单详情";
    self.view.backgroundColor = [UIColor colorFromHexString:@"d8d8d8" alpha:0.4];
    
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addStudentInfo)];
    [addBarButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = addBarButton;
    self.dataArray = [NSMutableArray array];
    self.hisDetailArray = [NSMutableArray array];
    self.allStuInfo = [NSMutableArray array];
    self.stringsToSort = [NSMutableArray array];
    self.stuIdArray = [NSMutableArray array];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"hisId"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@0 forKey:@"hisId"];
    }
    
    //------------分组
//    self.indexArray = [NSMutableArray array];//[ChineseString IndexArray:[self.dataArray objectAtIndex:2]];
//    self.letterResultArr = [NSMutableArray array];//[ChineseString LetterSortArray:[self.dataArray objectAtIndex:2]];
//    self.stringsToSort = [NSMutableArray array];
    
    [self initTableView];

    [self initEmptyView];
    
    [self initLoadAddStuInfoListView];
    
    [self initFootView];
}

//初始化table
- (void)initTableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,30,SCREEN_WIDTH, SCREEN_HEIGHT - 130) style:UITableViewStylePlain];//UITableViewStyleGrouped
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorFromHexString:@"d8d8d8" alpha:0.4];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        [_tableView reloadData];
    }
    
//    //获得row
//    NSInteger row = [[_tableView indexPathForCell:(UITableViewCell *)[sender superview]] row];
//    //获得indexPath
//    NSIndexPath *indexPath = [_tableView indexPathForCell:(UITableViewCell *)[sender superview]];

}

#pragma mark - 初始化列表为空的ui
- (void)initEmptyView{
    emptyView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    emptyView.backgroundColor = [UIColor whiteColor];
    [emptyView setHidden:YES];
    [self.view addSubview:emptyView];
    
    UIImageView *headLoadFailedImageV = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH / 2) - 35, 40, 70, 70)];
    headLoadFailedImageV.image = [UIImage imageNamed:@"stu_load_failed"];
    [emptyView addSubview:headLoadFailedImageV];
    
    NSString * str = @"您的名单还没有联系人，您可以通过iTunes导入或者通过右上角的号添加。如果添加的过程中遇到问题，请查看帮助文档，或者联系技术团队，他们会给您一个完美的答案！";
    //初始化textView
    self.edgesForExtendedLayout = UIRectEdgeNone;
    textView = [[UITextView alloc]  initWithFrame:CGRectMake(20, 110, [UIScreen mainScreen].bounds.size.width - 30, [UIScreen mainScreen].bounds.size.height - 40 - 44 - 20)];
    
    textView.backgroundColor = [UIColor clearColor];
    textView.text = str;
    textView.textColor = [UIColor grayColor];
    
    textView.font = [UIFont systemFontOfSize:18];
    textView.editable = NO;
    textView.delegate = self;
    [emptyView addSubview:textView];
    
    //设置常规属性
    [self setupNormalAttribute];
    //链接和图片
    [self setupImageAndLink];
    
}

#pragma mark -链接和图片
- (void)setupImageAndLink {
    NSMutableAttributedString * mutStr = [textView.attributedText mutableCopy];
    //添加表情
    UIImage * addImage = [UIImage imageNamed:@"stu_add_icon"];
    NSTextAttachment * attachment = [[NSTextAttachment alloc] init];
    attachment.bounds = CGRectMake(0, 0, 16, 16);
    attachment.image = addImage;
    NSAttributedString * attachStr = [NSAttributedString attributedStringWithAttachment:attachment];
    [mutStr insertAttributedString:attachStr atIndex:32];
    
    //添加链接
    NSURL * url = [NSURL URLWithString:@"http://www.baidu.com"];
    [mutStr addAttribute:NSLinkAttributeName value:url range:NSMakeRange(16, 8)];
    
    NSURL * urlHelp = [NSURL URLWithString:@"http://www.baidu.com"];
    [mutStr addAttribute:NSLinkAttributeName value:urlHelp range:NSMakeRange(53, 4)];
    
    NSURL * urlTechnology = [NSURL URLWithString:@"http://www.baidu.com"];
    [mutStr addAttribute:NSLinkAttributeName value:urlTechnology range:NSMakeRange(60, 6)];
    
    textView.attributedText = [mutStr copy];
}

#pragma mark -设置常规属性
- (void)setupNormalAttribute {
    
    NSMutableAttributedString * mutStr = [textView.attributedText mutableCopy];
    
    //下划线
    [mutStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid) range:NSMakeRange(16, 8)];
    
    [mutStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid) range:NSMakeRange(52, 4)];
    
    [mutStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid) range:NSMakeRange(59, 6)];
    
    textView.attributedText = [mutStr copy];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    
    NSLog(@"%@", textAttachment); return NO;
    
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    [[UIApplication sharedApplication] openURL:URL]; 
    
    return YES; 
    
}

#pragma mark -添加学生信息选项
-(void)initLoadAddStuInfoListView{
    //几个model
    RightAlertListCellModel *one = [[RightAlertListCellModel alloc] initWithTitle:@"Itunes导入" imageName:@"stu_import_icon"];
    RightAlertListCellModel *two = [[RightAlertListCellModel alloc] initWithTitle:@"批量添加" imageName:@"stu_batch_icon"];
    RightAlertListCellModel *three = [[RightAlertListCellModel alloc] initWithTitle:@"手动添加" imageName:@"stu_manual_icon"];
    RightAlertListCellModel *four = [[RightAlertListCellModel alloc] initWithTitle:@"扫一扫" imageName:@"stu_QRcode_icon"];
    dataArr = @[one, two, three, four];
}

#pragma mark - footView
- (void)initFootView{
    footView = [[UIView alloc] init];
    footView.size = CGSizeMake(SCREEN_WIDTH, 100);
    footView.userInteractionEnabled = YES;
    footView.backgroundColor = [UIColor whiteColor];//[UIColor colorFromHexString:@"8abaf4" alpha:1];
    
    UIView *finishView = [[UIView alloc] initWithFrame:CGRectMake(20, 2, SCREEN_WIDTH - 40, 34)];
    finishView.layer.cornerRadius = 5;
    finishView.backgroundColor = [UIColor colorFromHexString:@"8abaf4" alpha:1];
    finishView.userInteractionEnabled = YES;
    [footView addSubview:finishView];
    [finishView setTapActionWithBlock:^{
        int hisId = 0;
        // 用户 id 如果没有就存个0 如果有值新建的用户 id 对比上个用户 id +1
        NSNumber *lastId = [[NSUserDefaults standardUserDefaults] objectForKey:@"hisId"];

        hisId = lastId.intValue;
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        HistoryModel *hisModel = [CoreDataManager insertNewObjectForEntityForName:[HistoryModel class]];
        hisModel.classNames = self.classNames;
        hisModel.classId = self.classId;
        hisModel.createTime = currentDate;
        hisModel.historyId = @(hisId);
        [[NSUserDefaults standardUserDefaults]setObject:@(hisId + 1) forKey:@"hisId"];
        [self.hisDetailArray removeAllObjects];
        
        NSError *error  = nil;
        [CoreDataManager save:&error];
        if (!error) {
//           [showSuccess ]
            [ProgressHUD showSuccess:@"点名完成" delay:1.0];
            [self.hisDetailArray removeAllObjects];
            [self loadDatas];
            
        }
        
    }];
    
    UILabel *checkFinishLabel = [[UILabel alloc] initWithFrame:CGRectMake(finishView.center.x - 44, finishView.center.y - 10, 80, 20)];
    checkFinishLabel.text = @"点名完成";
    checkFinishLabel.font = [UIFont systemFontOfSize:14];
    checkFinishLabel.textColor = [UIColor whiteColor];
    [finishView addSubview:checkFinishLabel];
    
    UIView *checkView = [[UIView alloc] initWithFrame:CGRectMake(20, 54, SCREEN_WIDTH - 40, 34)];
    checkView.layer.cornerRadius = 5;
    checkView.backgroundColor = [UIColor colorFromHexString:@"8abaf4" alpha:1];
    checkView.userInteractionEnabled = YES;
    [footView addSubview:checkView];
    [checkView setTapActionWithBlock:^{
        NSLog(@"随机点名");
        JWRandomViewController *randomVC =  [[JWRandomViewController alloc] init];
        //randomVC.stuNamesArray = [NSMutableArray array];
        randomVC.stuNamesArray = self.stringsToSort;
        [self.navigationController pushViewController:randomVC animated:YES];
        
    }];
    
    UILabel *checkLabel = [[UILabel alloc] initWithFrame:CGRectMake(finishView.center.x - 44, finishView.center.y - 10, 80, 20)];
    checkLabel.text = @"随机点名";
    checkLabel.font = [UIFont systemFontOfSize:14];
    checkLabel.textColor = [UIColor whiteColor];
    [checkView addSubview:checkLabel];

}

//添加班级选择
- (void)addStudentInfo{
    
    CGFloat x = SCREEN_WIDTH - 10;
    CGFloat y = 60;
    rightAlertListV = [[JWRightAlertListView alloc] initWithDataArray:dataArr origin:CGPointMake(x, y) width:130 height:33];
    rightAlertListV.delegate = self;
    rightAlertListV.dismissOperation = ^(){
        //设置成nil，以防内存泄露
        rightAlertListV = nil;
    };
    [rightAlertListV pop];
}

#pragma mark JWAddStudentInfoListViewDelegate - 代理
- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        JWiTunesViewController *iTunesVC =  [[JWiTunesViewController alloc] init];
        [self.navigationController pushViewController:iTunesVC animated:YES];
        
    } else if (indexPath.row == 1) {
        JWBatchAddStudentInfoViewController *batchAddVC =  [[JWBatchAddStudentInfoViewController alloc] init];
        batchAddVC.classId = self.classId;
        [self.navigationController pushViewController:batchAddVC animated:YES];
        
    } else if (indexPath.row == 2) {
        JWManualAddStudentInfoViewController *manualAddVC =  [[JWManualAddStudentInfoViewController alloc] init];
        manualAddVC.classId = self.classId;
        [self.navigationController pushViewController:manualAddVC animated:YES];
        
    } else if (indexPath.row == 3) {
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
            output.metadataObjectTypes = a;
        }
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        self.previewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        self.previewLayer.frame = scanView.layer.bounds;
        [scanView.layer addSublayer:self.previewLayer];
        
        [self setOverlayPickerView];
        
        [_session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:nil];
        
        //开始捕获
        [_session startRunning];
    }
}

#pragma mark --
#pragma mark - 二维码扫描签到代理
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    NSString *allStudentsInfo;
    if (metadataObjects != nil && [metadataObjects count] > 0){
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        
        if ([[metadataObject type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            allStudentsInfo = metadataObject.stringValue;
            NSArray *arrayStu;
            NSArray *arrayStuDetail;
            
            if (![NSString isEmptyString:allStudentsInfo]) {
                NSString *string = [NSString stringWithFormat:@"%@",allStudentsInfo];
                
                arrayStu = [string componentsSeparatedByString:@"#"]; //从字符
                
                for (int i = 0; i < arrayStu.count; i++) {
                    NSString *string1 = arrayStu[i];
                    arrayStuDetail = [string1 componentsSeparatedByString:@","]; //从字符
                    
                    int stuId = 0;
                    // 用户 id 如果没有就存个0 如果有值新建的用户 id 对比上个用户 id +1
                    NSNumber *lastId = [[NSUserDefaults standardUserDefaults] objectForKey:@"stuAllId"];
                    if (lastId)
                    {
                        stuId = lastId.intValue + 1;
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@(stuId) forKey:@"stuAllId"];
                    }
                    
                    StudentModel *stuModel = [CoreDataManager insertNewObjectForEntityForName:[StudentModel class]];
                    stuModel.stuNames = arrayStuDetail[0];
                    stuModel.stuSex = arrayStuDetail[1];
                    stuModel.stuPhone = arrayStuDetail[2];
                    stuModel.stuNote = arrayStuDetail[3];
                    stuModel.stuId = @(stuId);
                    stuModel.classId = self.classId;
                    
                    [self.allStuInfo addObject:stuModel];
                }
            }
            
            NSError *error  = nil;
            [CoreDataManager save:&error];
            if (!error) {
                [ProgressHUD showSuccess:@"添加用户成功" delay:1.0];
                [emptyView setHidden:YES];
            }
            
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
    CABasicAnimation *animation = [JWListDetailViewController moveYTime:2 fromY:[NSNumber numberWithFloat:0] toY:[NSNumber numberWithFloat:SCREEN_WIDTH -60 - 2] rep:OPEN_MAX];
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
    UIImageView* upView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 60, (self.view.center.y - ( SCREEN_WIDTH - 60 ) / 2) + 1 )];
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
//状态栏设置为白色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark UITableViewDataSource - 代理
#pragma mark - UITableViewDataSource 方法

//------------分组
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [[self.letterResultArr objectAtIndex:section] count];
//}

//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return self.indexArray;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSString *key = [self.indexArray objectAtIndex:section];
//    return key;
//}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return [self.indexArray count];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
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
        _cell = [ListDetailTableViewCell stuListCellWithReuseIdentifier:CellIdentifier andType:nil];
        _cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    }
    StudentModel *stu = self.dataArray[indexPath.row];
    
    //------------分组
    //stu.stuNote = [self.dataArray[indexPath.row] objectAtIndex:0];
    //stu.stuNames = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    // NSLog(@"-------%@--- %@--",[[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row],[self.dataArray  objectAtIndexedSubscript:1]);

    _cell.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
    [_cell drawCellWithData:stu];
    
    return _cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TableCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];//点击后动画消失
    _cell = [tableView  cellForRowAtIndexPath:indexPath];
    _cell.backgroundColor = [UIColor colorFromHexString:@"737373" alpha:0.3];
     StudentModel *stu = _dataArray[indexPath.row];
     __weak typeof(self) wSelf = self;
    //考勤点击
    [_cell.leaveImageView setTapActionWithBlock:^{  //请假
        wSelf.cell.leaveImageView.image = [UIImage imageNamed:@"stu_leave_sel_icon"];
        wSelf.cell.attentImageView.image = [UIImage imageNamed:@"stu_attent_icon"];
        wSelf.cell.absenceImageView.image = [UIImage imageNamed:@"stu_absence_icon"];
        attendanceStatus = 0;
        [wSelf updateHistoryWithStudentModel:stu];
    }];
    
    [_cell.absenceImageView setTapActionWithBlock:^{ //缺席
        wSelf.cell.leaveImageView.image = [UIImage imageNamed:@"stu_leave_icon"];
        wSelf.cell.attentImageView.image = [UIImage imageNamed:@"stu_attent_icon"];
        wSelf.cell.absenceImageView.image = [UIImage imageNamed:@"stu_absence_sel_icon"];
        attendanceStatus = 1;
        [wSelf updateHistoryWithStudentModel:stu];
    }];
    
    [_cell.attentImageView setTapActionWithBlock:^{  //出席
        wSelf.cell.leaveImageView.image = [UIImage imageNamed:@"stu_leave_icon"];
        wSelf.cell.attentImageView.image = [UIImage imageNamed:@"stu_attent_sel_icon"];
        wSelf.cell.absenceImageView.image = [UIImage imageNamed:@"stu_absence_icon"];
        attendanceStatus = 2;
        [wSelf updateHistoryWithStudentModel:stu];
    }];
   
    
//    NSDate *currentDate = [NSDate date];//获取当前时间，日期
//    int statisticsId = 0;
//    // 用户 id 如果没有就存个0 如果有值新建的用户 id 对比上个用户 id +1
//    NSNumber *lastStatisticsId = [[NSUserDefaults standardUserDefaults] objectForKey:@"statisticsId"];
//    if (lastStatisticsId)
//    {
//        statisticsId = lastStatisticsId.intValue + 1;
//        
//    } else {
//        
//        [[NSUserDefaults standardUserDefaults]setObject:@0 forKey:@"statisticsId"];
//    }
    
//    StatisticsModel *statisticsModel = [CoreDataManager insertNewObjectForEntityForName:[StatisticsModel class]];
//    if (attendanceStatus == 0 ) {
//        
//        statisticsModel.leave = @(3);
//        
//    } else if (attendanceStatus == 1) {
//        
//        statisticsModel.absence = @(2);
//       
//    } else if (attendanceStatus == 2) {
//        
//        statisticsModel.attent = @(1);
//    }
//    
//    statisticsModel.statisticsId = @(statisticsId);
//    statisticsModel.statisticsTime = currentDate;
//    statisticsModel.stuId = stu.stuId;
//    statisticsModel.stuNames = stu.stuNames;
    
}

- (void) updateHistoryWithStudentModel:(StudentModel*)stu{
    
    HistoryDetailModel *hisDetailModel = [CoreDataManager insertNewObjectForEntityForName:[HistoryDetailModel class]];
    hisDetailModel.attendance = @(attendanceStatus);
    hisDetailModel.historyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"hisId"];//hisModel.historyId;
    hisDetailModel.classId = self.classId;
    hisDetailModel.stuId = stu.stuId;
    hisDetailModel.stuNames = stu.stuNames;
    hisDetailModel.stuNote = stu.stuNote;
    hisDetailModel.hisDetailId = hisDetailModel.stuId;
    
    if (self.hisDetailArray.count == 0) {
        
        [self.hisDetailArray addObject:hisDetailModel];
        
    } else {
        for (int i = 0; i < self.hisDetailArray.count; i++) {
            
            HistoryDetailModel *hisTemp = self.hisDetailArray[i];
            if (hisTemp.stuId == hisDetailModel.stuId) {
                
                [self.hisDetailArray replaceObjectAtIndex:i withObject:hisDetailModel];
                
            } else if ((hisDetailModel.stuId != hisTemp.stuId) && (i == self.hisDetailArray.count - 1)) {
                
                [self.hisDetailArray addObject:hisDetailModel];
            }
        }
    }
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath && self.dataArray.count==0) {
        return;
    }
    __weak UITableView *table = tableView;
    __weak StudentModel *stu = self.dataArray[indexPath.row];
    // 设置查询条件 通过用户名 和 id 来约束查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stuNames = %@ and stuId = %@",stu.stuNames,stu.stuId];
    // 删除之前需要先查询 找了那个对象才能执行删除的操作
    [CoreDataManager executeFetchRequest:[StudentModel class] predicate:predicate complete:^(NSArray *array, NSError *error) {
        if (array && array.count>0) {
            // 取出结果数组里的模型 并删除 然后保存上下文
            for (StudentModel *stu in array) {
                [CoreDataManager deleteObject:stu];
            }
            NSError *error = nil;
            // 保存上下文就存储数据
            [CoreDataManager save:&error];
            if (!error) {
                [self.dataArray removeObject:stu];
            }
            //移除tableView中的数据
            [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [self.dataArray count]-1){
        _tableView.tableFooterView = footView;
        
    }
    
}

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
    
    // 设置查询条件 通过用户名 和 id 来约束查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"classId = %@",self.classId];
    //获取所有班级列表
    [CoreDataManager executeFetchRequest:[StudentModel class] predicate:predicate complete:^(NSArray *array, NSError *error)
     {
         [self.dataArray removeAllObjects];
         if (array && array.count > 0) {
             for (StudentModel *stu in array) {
                 [self.dataArray addObject:stu];
                 [self.stringsToSort addObject:stu.stuNames];
                 [self.stuIdArray addObject:stu.stuId];
             }
             [self getMaxStuId];
             //------------分组
             //self.indexArray = [ChineseString IndexArray:self.stringsToSort];
             //self.letterResultArr = [ChineseString LetterSortArray:self.stringsToSort];
             //-------------
             
             [_tableView reloadData];
         } else {
             [emptyView setHidden:NO];
             [[NSUserDefaults standardUserDefaults]setObject:@0 forKey:@"stuAllId"];
         }
     }];
}

-(void)getMaxStuId{
    if (self.stuIdArray.count > 0) {
        NSInteger max = [[self.stuIdArray valueForKeyPath:@"@max.intValue"] integerValue];
        [[NSUserDefaults standardUserDefaults]setObject:@(max) forKey:@"stuAllId"];
    }
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
