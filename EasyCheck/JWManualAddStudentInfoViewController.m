//
//  JWManualAddStudentInfoViewController.m
//  EasyCheck
//
//  Created by jinwei on 16/5/13.
//  Copyright © 2016年 Weijin. All rights reserved.
//

typedef enum {
    AddStuInfo, // 添加
    UploadStuInfo // 更新
}EditingType;

#import "JWManualAddStudentInfoViewController.h"
#import "GlobalDefinition.h"
#import "ProgressHUD.h"
#import "CoreDataManager.h"
#import "StudentModel.h"

@interface JWManualAddStudentInfoViewController()<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *stuNameField;
@property (strong, nonatomic) UITextField *stuNameNoteField;
@property (strong, nonatomic) UITextField *stuNumberField;
@property (strong, nonatomic) UITextField *stuSexField;
@property (strong, nonatomic) UITextField *stuPhoneField;

/**
 *  type
 */
@property(nonatomic,assign)EditingType type;

/**
 *  ClassList
 */
@property(nonatomic,strong)StudentModel *stuModel;

@end

@implementation JWManualAddStudentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加联系人";
    
    self.view.backgroundColor = [UIColor colorFromHexString:@"d8d8d8" alpha:0.4];
    
    //保存
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveClassList)];
    [addBarButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = addBarButton;
    
    //取消
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame =CGRectMake(0,0,30,40);
    leftBtn.titleLabel.font=[UIFont systemFontOfSize:15.0];
    [leftBtn setTitle:@"取消"forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancelClassList)forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    [self initContentView];
    
}

- (void)initContentView{
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 200)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 40, 30)];
    nameLabel.text = @"姓名:";
    nameLabel.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:nameLabel];
    
    self.stuNameField = [[UITextField alloc] initWithFrame:CGRectMake(50, 10, SCREEN_WIDTH - 65, 30)];
    self.stuNameField.placeholder = @"请输入名字";
    self.stuNameField.font = [UIFont systemFontOfSize:13];
    [self.stuNameField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [self.stuNameField becomeFirstResponder];
    [self.stuNameField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [contentView addSubview:self.stuNameField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 45, SCREEN_WIDTH, 1/[[UIScreen mainScreen] scale])];
    lineView.backgroundColor = [UIColor colorFromHexString:@"d8d8d8"];
    [contentView addSubview:lineView];
    
    
    UILabel *nameNoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 55, 40, 30)];
    nameNoteLabel.text = @"性别:";
    nameNoteLabel.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:nameNoteLabel];
    
    self.stuSexField = [[UITextField alloc] initWithFrame:CGRectMake(50, 55, SCREEN_WIDTH - 65, 30)];
    self.stuSexField.font = [UIFont systemFontOfSize:13];
    self.stuSexField.placeholder = @"请输入性别";
    [self.stuSexField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [self.stuSexField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [contentView addSubview:self.stuSexField];
    
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(15, 90, SCREEN_WIDTH, 1/[[UIScreen mainScreen] scale])];
    lineView1.backgroundColor = [UIColor colorFromHexString:@"d8d8d8"];
    [contentView addSubview:lineView1];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 100, 40, 30)];
    phoneLabel.text = @"电话:";
    phoneLabel.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:phoneLabel];
    
    self.stuPhoneField = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, SCREEN_WIDTH - 65, 30)];
    self.stuPhoneField.font = [UIFont systemFontOfSize:13];
    self.stuPhoneField.placeholder = @"请输入电话";
    [self.stuPhoneField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [self.stuPhoneField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [contentView addSubview:self.stuPhoneField];
    
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(15, 135, SCREEN_WIDTH, 1/[[UIScreen mainScreen] scale])];
    lineView2.backgroundColor = [UIColor colorFromHexString:@"d8d8d8"];
    [contentView addSubview:lineView2];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 145, 40, 30)];
    noteLabel.text = @"备注:";
    noteLabel.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:noteLabel];
    
    self.stuNameNoteField = [[UITextField alloc] initWithFrame:CGRectMake(50, 145, SCREEN_WIDTH - 65, 30)];
    self.stuNameNoteField.font = [UIFont systemFontOfSize:13];
    self.stuNameNoteField.placeholder = @"请输入备注，比如学号等信息";
    [self.stuNameNoteField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [self.stuNameNoteField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [contentView addSubview:self.stuNameNoteField];
    
}

#pragma mark - 保存
- (void)saveClassList{
    
    if ([self isEmpty:self.stuNameField]) {
        [ProgressHUD showError:@"姓名为空" delay:1.0];
        return;
    }else if ([self isEmpty:self.stuNameNoteField]){
        [ProgressHUD showError:@"备注为空" delay:1.0];
        return;
    } else if ([self isEmpty:self.stuPhoneField]) {
        [ProgressHUD showError:@"手机号为空" delay:1.0];
        return;
    } else if ([self isEmpty:self.stuSexField]) {
        [ProgressHUD showError:@"性别为空" delay:1.0];
        return;
    } else if ([self isEmpty:self.stuNumberField]) {
        [ProgressHUD showError:@"学号为空" delay:1.0];
        return;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    // 修改联系人信息
    if (self.stuModel && self.type == UploadStuInfo) {
        [self UploadStuInfo];
    }else{
        [self addStuInfo]; // 添加联系人
    }
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

/**
 *   添加联系人
 */
- (void)addStuInfo
{
    int stuId = 0;
    // 用户 id 如果没有就存个0 如果有值新建的用户 id 对比上个用户 id +1
    NSNumber *lastId = [[NSUserDefaults standardUserDefaults] objectForKey:@"stuId"];
    if (lastId)
    {
        stuId = lastId.intValue + 1;
        [[NSUserDefaults standardUserDefaults]setObject:@(stuId) forKey:@"stuId"];
    } else {
        
        [[NSUserDefaults standardUserDefaults]setObject:@0 forKey:@"stuId"];
    }
    
    StudentModel *stuModel = [CoreDataManager insertNewObjectForEntityForName:[StudentModel class]];
    stuModel.stuNames = self.stuNameField.text;
    stuModel.stuSex = self.stuSexField.text;
    stuModel.stuPhone = self.stuPhoneField.text;
    stuModel.stuNote = self.stuNameNoteField.text;
    stuModel.stuId = @(stuId);
    stuModel.stuNumber = self.stuNumberField.text;
    stuModel.classId = self.classId;
    
    NSError *error  = nil;
    [CoreDataManager save:&error];
    if (!error) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/**
 *   更新联系人资料
 */
- (void)UploadStuInfo
{
    __weak typeof(self) wSelf = self;
    // 设置查询条件 通过用户名 和 id 来约束查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stuNames = %@ and stuId = %@",self.stuModel.stuNames,self.stuModel.stuId];
    
    // 删除之前需要先查询 找了那个对象才能执行删除的操作
    [CoreDataManager executeFetchRequest:[StudentModel class] predicate:predicate complete:^(NSArray *array, NSError *error) {
        if (array && array.count>0) {
            // 取出结果数组里的模型 并删除 然后保存上下文
            for (StudentModel *stu in array) {
                stu.stuNames = self.stuNameField.text;
                stu.stuSex = self.stuSexField.text;
                stu.stuPhone = self.stuPhoneField.text;
                stu.stuNote = self.stuNameNoteField.text;
                stu.stuNumber = self.stuNumberField.text;
            }
            NSError *error = nil;
            // 保存上下文就存储数据
            [CoreDataManager save:&error];
            if (!error) {
                NSLog(@"修改成功");
            }
            [wSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

/**
 *   判断输入框输入的内容是否为空
 *
 *   @param textField 输入框
 *
 *   @return 返回一个result
 */
- (BOOL)isEmpty:(UITextField*)textField
{
    if ([textField.text isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

#pragma mark - 取消
- (void)cancelClassList{
    
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;//动画过渡类型
    transition.subtype = kCATransitionFromBottom;//动画过渡方向(子类型)
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];  //动画定时函数属性
    transition.duration = 0.35;  //动画持续时间
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}


@end
