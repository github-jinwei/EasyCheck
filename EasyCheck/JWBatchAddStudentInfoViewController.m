//
//  JWBatchAddStudentInfoViewController.m
//  EasyCheck
//
//  Created by jinwei on 16/5/13.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "JWBatchAddStudentInfoViewController.h"
#import "StudentModel.h"
#import "CoreDataManager.h"

@interface JWBatchAddStudentInfoViewController(){
    UITextView *stuInfoTextView;
    UILabel *hintLabel;
    
}
@property (strong, nonatomic) NSMutableArray *dataArray;      // 数据源stuId
@property (strong, nonatomic) NSMutableArray *allStuInfo;

@end

@implementation JWBatchAddStudentInfoViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"批量添加";
    self.view.backgroundColor = [UIColor colorFromHexString:@"d8d8d8" alpha:0.4];
    
    UIBarButtonItem *addBarButton =[[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addStudentInfo)];
    [addBarButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = addBarButton;
    self.dataArray = [NSMutableArray array];
    self.allStuInfo = [NSMutableArray array];
    [self initAddContentView];
}

-(void)initAddContentView{
    
    NSString * str = @"金威,男,18730603791,20142043232,软甲工程#王素燕,男,18730603793,20142043234,软甲工程#王燕,女,18730603755,20142043236,软甲工程#王涛,男,18730603799,,软甲工程";
    //初始化textView
    self.edgesForExtendedLayout = UIRectEdgeNone;
    stuInfoTextView = [[UITextView alloc]  initWithFrame:CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width - 30, 150)];
    
    stuInfoTextView.backgroundColor = [UIColor colorFromHexString:@"d8d8d8" alpha:0.5];
    stuInfoTextView.text = str;
    stuInfoTextView.textColor = [UIColor blackColor];
    
    stuInfoTextView.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:stuInfoTextView];
    
    hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, [UIScreen mainScreen].bounds.size.width - 30, 90)];
    hintLabel.numberOfLines = 0;
    hintLabel.text = @"人与人之间用＃号隔开，个人信息以逗号隔开，没有数据时用逗号代替，例如：金威,男,18730603799,20142043234,软甲工程#王素燕,男,,20142043234,软甲工程";
    hintLabel.font = [UIFont systemFontOfSize:14];
    hintLabel.textColor = [UIColor grayColor];
    [self.view addSubview:hintLabel];
    
    
}

- (void)addStudentInfo {
    
    
    NSArray *arrayStu;
    NSArray *arrayStuDetail;
    
    if (![NSString isEmptyString:stuInfoTextView.text]) {
        NSString *string = [NSString stringWithFormat:@"%@",stuInfoTextView.text];
        
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
        NSLog(@"添加成功");
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadDatas];
}

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
                 [self.dataArray addObject:stu.stuId];
             }
             [self getMaxStuId];
         } else {
             [[NSUserDefaults standardUserDefaults]setObject:@0 forKey:@"stuAllId"];
         }
     }];
}

-(void)getMaxStuId{
   if (self.dataArray.count > 0) {
         NSInteger max = [[self.dataArray valueForKeyPath:@"@max.intValue"] integerValue];
         [[NSUserDefaults standardUserDefaults]setObject:@(max) forKey:@"stuAllId"];
    }
}

@end
