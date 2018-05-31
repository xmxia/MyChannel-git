//
//  ViewController.m
//  MyChannel
//
//  Created by Apple on 2018/5/29.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveObjC.h"
#import "ChannelView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 60, 30)];
    [btn setTitle:@"111111" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:btn];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        ChannelView *cv = [[ChannelView alloc]initWithFrame:CGRectMake(0, self.view.height, self.view.width, self.view.height)];
        [[UIApplication sharedApplication].keyWindow addSubview:cv];
        [cv show];

    }];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
