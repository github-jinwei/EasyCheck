//
//  JWRandomViewController.m
//  EasyCheck
//
//  Created by jinwei on 16/5/24.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "JWRandomViewController.h"


@interface JWRandomViewController()
{
    UILabel *label;
    NSTimer *timer;
}


@end

@implementation JWRandomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"随机点名";
    self.view.backgroundColor = [UIColor colorFromHexString:@"d8d8d8" alpha:0.4];
    [self loadData];
    
    //self.view.backgroundColor = [UIColor grayColor];
    label = [[UILabel alloc]initWithFrame:CGRectMake(50, 200, 275, 50)];
    label.text = @"金威";
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:30];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREEN_WIDTH / 2 - 40, 280, 80, 40);
    [self.view addSubview:button];
    [button setTitle:@"点名" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorFromHexString:@"8abaf4" alpha:1];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.showsTouchWhenHighlighted = YES;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop ]addTimer:timer forMode:NSDefaultRunLoopMode];
    timer.fireDate = [NSDate distantFuture];
}



- (void)loadData
{
    int arcNumber = arc4random()%_stuNamesArray.count;
    NSString *tempName = [_stuNamesArray objectAtIndex:arcNumber];
    label.text = tempName;
}

- (void)push:(UIButton *)sender
{
    if (sender.selected !=YES ) {
        //label.textColor = [UIColor clearColor];
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
        timer.fireDate = [NSDate distantPast];
        sender.selected = YES;
    } else {
        timer.fireDate = [NSDate distantFuture];
        label.textColor = [UIColor blackColor];
        [sender setTitle:@"开始" forState:UIControlStateNormal];
        sender.selected = NO;
    }
    
}

//- (void)showAlertMessage:(NSString *)message
//{
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"真的是你" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
//    
//}
@end

