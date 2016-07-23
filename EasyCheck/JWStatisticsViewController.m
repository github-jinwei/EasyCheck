//
//  MMViewController.m
//  LUITabBarViewController
//
//  Created by JinWei on 16/4/22.
//  Copyright (c) 2013年 Oran Wu. All rights reserved.
//

#import "JWStatisticsViewController.h"
#import "GlobalDefinition.h"
#import "JWRightAlertListView.h"
#import "JWFoldListView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Utils.h"
#import "CodeFragments.h"
#import "RFSegmentView.h"
#import "DVBarChartView.h"
#import "CoreDataManager.h"
#import "ClassList.h"
#import "StudentModel.h"
#import "HistoryDetailModel.h"

@interface JWStatisticsViewController ()<JWRightAlertListViewDelegate,JWFoldListViewDelegate,DVBarChartViewDelegate>{
    NSArray *dataArr; //添加考勤选项列表
    JWRightAlertListView *rightAlertListV;
    NSMutableArray *titleArray;
    NSMutableArray *stuIdArray;
    NSMutableArray *valueArray;
    NSMutableArray *_dataArray; // 班级信息数据源数组
    NSNumber *attendanceFlag;   //考勤类型
    NSNumber *classIdFlag;
    
}

@property (nonatomic, strong)JWFoldListView *foldListV;
@property (nonatomic, strong)DVBarChartView *chartView;
@property (nonatomic, strong)RFSegmentView  *segmentView;
@property (nonatomic, assign)int dataNum;
@end

@implementation JWStatisticsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"缺勤统计";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(SelectCategoryList)];
    [addBarButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = addBarButton;
    _dataArray = [NSMutableArray array];
    titleArray = [NSMutableArray array];
    valueArray = [NSMutableArray array];
    stuIdArray = [NSMutableArray array];
    _dataNum = 30;
    [self loadDatas];
    
    [self initLoadRightAlertListView];//右上角加号
    
    [self initWithUISegmentedControlView];//分段选择器
    
    [self loadClassListView];//班级列表
    
}

- (void)initwithChartViewWithTitleArray:(NSArray *)xAxisTitleArray ValueArray:(NSArray*)xValues{
    
    self.chartView = [[DVBarChartView alloc] initWithFrame:CGRectMake(0, 228, SCREEN_WIDTH, 289)];
    [self.view addSubview:self.chartView];
    
    self.chartView.yAxisViewWidth = 52;
    self.chartView.numberOfYAxisElements = 2;
    self.chartView.barWidth = 15;
    self.chartView.xAxisTextGap = 3;
    self.chartView.barGap = 10;
    self.chartView.barColor = [UIColor colorFromHexString:@"52ba7d" alpha:1];
    self.chartView.axisColor = [UIColor colorFromHexString:@"0e25fc" alpha:1];
    self.chartView.backColor = [UIColor colorFromHexString:@"dcf2e8" alpha:1];
    self.chartView.textColor = [UIColor colorFromHexString:@"0e25fc" alpha:1];
    self.chartView.xAxisTitleArray = xAxisTitleArray;
    self.chartView.xValues = xValues;
    self.chartView.delegate = self;
    self.chartView.yAxisMaxValue = 30;
    [self.chartView draw];
}


//右角添加ui
- (void)initLoadRightAlertListView{
    //几个model
    RightAlertListCellModel *one = [[RightAlertListCellModel alloc] initWithTitle:@"缺勤统计"];//imageName:@"stu_absence_icon"
    RightAlertListCellModel *two = [[RightAlertListCellModel alloc] initWithTitle:@"请假统计"];//imageName:@"stu_leave_icon"
    RightAlertListCellModel *three = [[RightAlertListCellModel alloc] initWithTitle:@"正常统计"];//imageName:@"stu_attent_icon"

    dataArr = @[one, two, three];
}

//选择统计班级ui
- (void)loadClassListView{
    
    UIView *foldClickView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 44)];
    foldClickView.userInteractionEnabled = YES;
    [self.view addSubview:foldClickView];
    
    self.foldListV = [[JWFoldListView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 44) dataArray:_dataArray];
    self.foldListV.userInteractionEnabled = YES;
    self.foldListV.jwDelegate = self;
    self.foldListV.backgroundColor = [UIColor whiteColor];
    self.foldListV.jwFontSize = 14;
    self.foldListV.jwHeight = 40;
    self.foldListV.foldListViewType = FoldListViewRight;
    [self initDottedLineView:self.foldListV];
    ClassList *c = [_dataArray objectAtIndex:0];
    classIdFlag = c.classId;//获取默认班级id
    [self loadTitleArrayWithClassId:classIdFlag attendance:@(1)];
    
    [self.foldListV jwSetTitle:c.classNames forState:UIControlStateNormal];
    [self.foldListV jwSetTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.foldListV];
    
     __weak typeof(self) wSelf = self;
    [foldClickView setTapActionWithBlock:^{
        NSLog(@"rrrrr%d",wSelf.foldListV.jwSelected);
        
        if (wSelf.foldListV.jwSelected) {
            [wSelf.foldListV jwCloseTable];
        } else {
            [wSelf.foldListV jwOpenTable];
        }
    }];
    
}

//添加虚线ui
- (void)initDottedLineView:(JWFoldListView*) foldListView{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:foldListView.bounds];
    
    [shapeLayer setPosition:CGPointMake(foldListView.center.x, foldListView.center.y - 16)];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0f] CGColor]];
    
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:1],nil]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    
    // 0,10代表初始坐标的x，y
    // 320,10代表初始坐标的x，y
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, SCREEN_WIDTH,0);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    // 可以把self改成任何你想要的UIView
    [[foldListView layer] addSublayer:shapeLayer];
}

//设置分类列表
- (void)SelectCategoryList{
    CGFloat x = SCREEN_WIDTH - 10;
    CGFloat y = 60;
    rightAlertListV = [[JWRightAlertListView alloc] initWithDataArray:dataArr origin:CGPointMake(x, y) width:90 height:34];
    rightAlertListV.delegate = self;
    rightAlertListV.dismissOperation = ^(){
        //设置成nil，以防内存泄露
        rightAlertListV = nil;
    };
    [rightAlertListV pop];

}

- (void)initWithUISegmentedControlView{
    NSMutableArray *arrayData       = [NSMutableArray arrayWithObjects:@"30天",@"90天",@"全部",@"自定义", nil];
    [self initWithLoadSegmentView:arrayData];
    
    NSArray *arrayAddMinus          = @[@"-",@"+"];
    CGFloat initAddMinusX           = 140;
    CGFloat initAddMinusY           = 160;
    CGFloat initAddMinusWidth       = 100;
    CGFloat initAddMinusHeight      = 40;
    
    RFSegmentView* segmentAddMinusView = [[RFSegmentView alloc] initWithFrame:CGRectMake(initAddMinusX, initAddMinusY, initAddMinusWidth, initAddMinusHeight) items:arrayAddMinus];
    segmentAddMinusView.tintColor       = [UIColor colorFromHexString:@"157cf6" alpha:1];
    segmentAddMinusView.selectedIndex   = 0;
    segmentAddMinusView.itemHeight      = 30.f;
     __weak typeof(self) wSelf = self;
    segmentAddMinusView.handlder = ^ (RFSegmentView * __nullable view, NSInteger selectedIndex) {
        NSLog(@"view:%@ selectedIndex666: %ld",view,(long)selectedIndex);
        //[self.segmentView removeFromSuperview];
        if (selectedIndex == 0) {
            [arrayData replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d天",_dataNum += 1]];
            NSLog(@"-------%@",arrayData);
            //[wSelf initWithLoadSegmentView:arrayData];
            [wSelf initwithChartViewWithTitleArray:@[@"金威",@"陆星",@"张凯",@"康少朋",@"崔慧彩",@"赵红飞"] ValueArray:@[@6,@5,@3,@0,@8,@2]];
           
        } else {
            [arrayData replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d天",_dataNum -= 1]];
            NSLog(@"-------%@",arrayData);
            [wSelf initwithChartViewWithTitleArray:@[@"金威",@"陆星",@"张凯",@"康少朋",@"崔慧彩",@"赵红飞"] ValueArray:@[@8,@7,@5,@2,@10,@4]];
        }
    };
    
    [self.view addSubview:segmentAddMinusView];
}

-(void)initWithLoadSegmentView:(NSArray *) array {
    
    CGFloat initX           = 50;
    CGFloat initY           = 110;
    CGFloat viewWidth       = 280;
    CGFloat viewHeight      = 40;
    self.segmentView = [[RFSegmentView alloc] initWithFrame:CGRectMake(initX, initY, viewWidth, viewHeight) items:array];
    self.segmentView.tintColor       = [UIColor colorFromHexString:@"157cf6" alpha:1];
    self.segmentView.selectedIndex   = 0;
    self.segmentView.itemHeight      = 30.f;
     __weak typeof(self) wSelf = self;
    self.segmentView.handlder = ^ (RFSegmentView * __nullable view, NSInteger selectedIndex) {
        NSLog(@"view:%@ selectedIndex666: %ld",view,(long)selectedIndex);
        
        if (selectedIndex == 0) {
//            [wSelf loadTitleArrayWithClassId:classIdFlag attendance:@(1)];
            [wSelf initwithChartViewWithTitleArray:@[@"金威",@"陆星",@"张凯",@"康少朋",@"崔慧彩",@"赵红飞"] ValueArray:@[@1,@2,@3,@1,@2,@3]];
        } else if (selectedIndex == 1) {
//            [wSelf loadTitleArrayWithClassId:classIdFlag attendance:@(1)];
            [wSelf initwithChartViewWithTitleArray:titleArray ValueArray:valueArray];
        } else if (selectedIndex == 2) {
//            [wSelf loadTitleArrayWithClassId:classIdFlag attendance:@(1)];
           [wSelf initwithChartViewWithTitleArray:@[@"金威",@"陆星",@"张凯",@"康少朋",@"崔慧彩",@"赵红飞"] ValueArray:@[@7,@6,@4,@1,@9,@3]];
        } else if ( selectedIndex == 3) {
//            [wSelf loadTitleArrayWithClassId:classIdFlag attendance:@(1)];
            [wSelf initwithChartViewWithTitleArray:titleArray ValueArray:valueArray];
        }
        
    };
    
    [self.view addSubview:self.segmentView];
    
}

#pragma mark DVBarChartViewDelegate - 代理
- (void)barChartView:(DVBarChartView *)barChartView didSelectedBarAtIndex:(NSInteger)index {
    
    NSLog(@"%ld", index);
    
}

#pragma mark JWAddStudentInfoListViewDelegate - 代理
- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        self.title = @"缺勤统计";
        [self loadTitleArrayWithClassId:classIdFlag attendance:@(1)];
        
    } else if (indexPath.row == 1) {
        self.title = @"请假统计";
        [self loadTitleArrayWithClassId:classIdFlag attendance:@(0)];
        
    } else if (indexPath.row == 2) {
        self.title = @"正常统计";
        [self loadTitleArrayWithClassId:classIdFlag attendance:@(2)];
    }
}

#pragma mark JWFoldListViewDelegate - 代理
-(void)JWFoldListView:(JWFoldListView *)foldListView didSelectObject:(id)obj{
    [self loadTitleArrayWithClassId:obj attendance:@(1)];
    classIdFlag = obj;
    
}

-(void)loadTitleArrayWithClassId:(id)classId attendance:(NSNumber *)attendance{
    // 设置查询条件 通过用户名 和 id 来约束查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"classId = %@",classId];
    //获取所有班级列表
    [CoreDataManager executeFetchRequest:[StudentModel class] predicate:predicate complete:^(NSArray *array, NSError *error)
     {
         [titleArray removeAllObjects];
         [stuIdArray removeAllObjects];
        
         if (array && array.count > 0) {
             for (StudentModel *stu in array) {
                 [titleArray addObject:stu.stuNames];
                 [stuIdArray addObject:stu.stuId];
             }
             [valueArray removeAllObjects];
             for (NSNumber *stuId in stuIdArray) {
                 NSPredicate *predicateHisDetail = [NSPredicate predicateWithFormat:@"classId = %@  and  stuId = %@ and attendance = %@",classId,stuId,attendance];
                 [CoreDataManager executeFetchRequest:[HistoryDetailModel class] predicate:predicateHisDetail complete:^(NSArray *array, NSError *error) {
                     
                     if (array && array.count > 0) {
                         [valueArray addObject:@(array.count)];
                     }
                 }];
             }
             
         }
     }];
    
    [self initwithChartViewWithTitleArray:titleArray ValueArray:valueArray];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadDatas];
    [self loadClassListView];
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
         if (array && array.count > 0) {
             for (ClassList *c in array) {
                 [_dataArray addObject:c];
             }
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
