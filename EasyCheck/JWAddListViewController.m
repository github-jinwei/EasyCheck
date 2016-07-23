//
//  JWAddListViewController.m
//  EasyCheck
//
//  Created by JinWei on 16/4/24.
//  Copyright © 2016年 Weijin. All rights reserved.
//


#import "JWAddListViewController.h"
#import "GlobalDefinition.h"
#import "ProgressHUD.h"
#import "CoreDataManager.h"
#import "ClassList.h"

@interface JWAddListViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *nameField;
@property (strong, nonatomic) UITextField *nameNoteField;

@end

@implementation JWAddListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加名单";
    
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
    
    if (self.editType == UploadClassList) {
        [self initLoadClassInfo];
    }
    
}

- (void)initContentView{
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 90)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 40, 30)];
    nameLabel.text = @"名称:";
    nameLabel.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:nameLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 45, SCREEN_WIDTH, 1/[[UIScreen mainScreen] scale])];
    lineView.backgroundColor = [UIColor colorFromHexString:@"d8d8d8"];
    [contentView addSubview:lineView];
    
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(50, 10, SCREEN_WIDTH - 65, 30)];
    self.nameField.placeholder = @"请输入名单的名称";
    self.nameField.font = [UIFont systemFontOfSize:13];
    [self.nameField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [self.nameField becomeFirstResponder];
    [self.nameField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [contentView addSubview:self.nameField];
    
    UILabel *nameNoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 55, 40, 30)];
    nameNoteLabel.text = @"备注:";
    nameNoteLabel.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:nameNoteLabel];
    
    self.nameNoteField = [[UITextField alloc] initWithFrame:CGRectMake(50, 55, SCREEN_WIDTH - 65, 30)];
    self.nameNoteField.font = [UIFont systemFontOfSize:13];
    self.nameNoteField.placeholder = @"请输入备注信息，方便查找";
    [self.nameNoteField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [self.nameNoteField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [contentView addSubview:self.nameNoteField];
    
}

- (void)initLoadClassInfo {
    self.nameField.text = self.listModel.classNames;
    self.nameNoteField.text = self.listModel.classNote;
}

#pragma mark - 保存
- (void)saveClassList{

    if ([self isEmpty:self.nameField]) {
        [ProgressHUD showError:@"名单为空" delay:1.0];
        return;
    }else if ([self isEmpty:self.nameNoteField]){
        [ProgressHUD showError:@"备注为空" delay:1.0];
        return;
    }
    self.navigationItem.rightBarButtonItem.enabled = NO;
    // 修改联系人信息
    if (self.listModel && self.editType == UploadClassList) {
        [self uploadClassInfo];
    }else{
        [self addClassInfo]; // 添加联系人
    }
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

/**
 *   添加联系人
 */
- (void)addClassInfo
{
    int classId = 0;
    // 用户 id 如果没有就存个0 如果有值新建的用户 id 对比上个用户 id +1
    NSNumber *lastId = [[NSUserDefaults standardUserDefaults] objectForKey:@"classId"];
    if (lastId)
    {
        classId = lastId.intValue +1;
        [[NSUserDefaults standardUserDefaults]setObject:@(classId) forKey:@"classId"];
    } else {
        
        [[NSUserDefaults standardUserDefaults]setObject:@0 forKey:@"classId"];
    }
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    ClassList *classList = [CoreDataManager insertNewObjectForEntityForName:[ClassList class]];
    classList.classNames  = self.nameField.text;
    classList.classNote  = self.nameNoteField.text;
    classList.createTime = dateString;
    classList.classId = @(classId);
    NSError *error  = nil;
    [CoreDataManager save:&error];
    if (!error) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/**
 *   更新联系人资料
 */
- (void)uploadClassInfo
{
     __weak typeof(self) wSelf = self;
    // 设置查询条件 通过用户名 和 id 来约束查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"classNames = %@ and classId = %@",self.listModel.classNames,self.listModel.classId];
    //
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YY/MM/dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    // 删除之前需要先查询 找了那个对象才能执行删除的操作
    [CoreDataManager executeFetchRequest:[ClassList class] predicate:predicate complete:^(NSArray *array, NSError *error) {
        if (array && array.count>0) {
            // 取出结果数组里的模型 并删除 然后保存上下文
            for (ClassList *l in array) {
                l.classNames = wSelf.nameField.text;
                l.classNote = wSelf.nameNoteField.text;
                l.createTime = dateString;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
