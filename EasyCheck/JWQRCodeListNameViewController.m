//
//  JWQRCodeListNameViewController.m
//  EasyCheck
//
//  Created by jinwei on 16/5/15.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "JWQRCodeListNameViewController.h"
#import "CoreDataManager.h"
#import "ClassList.h"
#import "JWFoldListView.h"
#import "UIView+Utils.h"
#import "GlobalDefinition.h"

@interface JWQRCodeListNameViewController()<JWFoldListViewDelegate>{
    NSMutableArray *_dataArray; // 班级信息数据源数组
}

@property (nonatomic, strong)JWFoldListView *foldListV;

@end

@implementation JWQRCodeListNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"二维码名单";
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    
    [self loadDatas];
    
    [self loadClassListView];//班级列表
    
    [self initWithQRCodeView];
    
    
}

//选择统计班级ui
- (void)loadClassListView{
    //NSArray *arr = @[@"软件工程1班",@"软件工程2班",@"计算机科学与技术1班"];
    //    self.view.backgroundColor = [UIColor grayColor];
    
    UIView *foldClickView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    foldClickView.userInteractionEnabled = YES;
    [self.view addSubview:foldClickView];
    
    self.foldListV = [[JWFoldListView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) dataArray:_dataArray];
    self.foldListV.userInteractionEnabled = YES;
    self.foldListV.jwDelegate = self;
    self.foldListV.backgroundColor = [UIColor whiteColor];
    self.foldListV.jwFontSize = 14;
    self.foldListV.jwHeight = 40;
    self.foldListV.foldListViewType = FoldListViewRight;
    [self initDottedLineView:self.foldListV];
    ClassList *c = [_dataArray objectAtIndex:0];
    [self.foldListV jwSetTitle:c.classNames forState:UIControlStateNormal];
    [self.foldListV jwSetTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[foldListV jwSetImage:[UIImage imageNamed:@"address_select"] forState:UIControlStateNormal];
    //[self.foldListV jwSetImage:[UIImage imageNamed:@"statistics_arrow"] forState:UIControlStateSelected];
    [self.view addSubview:self.foldListV];
    
    __weak typeof(self) wSelf = self;
    [foldClickView setTapActionWithBlock:^{
        NSLog(@"%d",wSelf.foldListV.jwSelected);
        
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
    
    [shapeLayer setPosition:CGPointMake(foldListView.center.x, foldListView.center.y + 45)];
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


- (void)initWithQRCodeView {
    UIImageView *qrCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) / 2, (SCREEN_HEIGHT - 150) / 2 - 30, 150, 150)];
    qrCodeImageView.image = [UIImage imageNamed:@"set_qr_code_class_info_icon"];
    [self.view addSubview:qrCodeImageView];
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
         if (array && array.count>0) {
             for (ClassList *c in array) {
                 [_dataArray addObject:c];
             }
         }
     }];
}

@end
