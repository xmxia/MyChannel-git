//
//  HeaderView.m
//  MyChannel
//
//  Created by Apple on 2018/5/29.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle needEditBtn:(BOOL)needEditBtn{
 
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:0].firstObject;
    self.channelLabel.text = title;
    self.detailLabel.text = title;
    self.editBtn.hidden = !needEditBtn;
    self.editBtn.layer.cornerRadius = 10;
    UIColor *color = [UIColor colorWithRed:0.93 green:0.37 blue:0.47 alpha:1.0];
    self.editBtn.layer.borderColor = color.CGColor;
    [self.editBtn setTitleColor:color forState:UIControlStateNormal];
    [self.editBtn setTitleColor:color forState:UIControlStateSelected];
    self.editBtn.layer.borderWidth = 1;
    self.detailLabel.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1.0];
    return self;
    
}
- (IBAction)btnClick:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.detailLabel.text = @"拖拽可以排序";
    }else {
        self.detailLabel.text = @"点击进入频道";
    }
    if (_callBack) {
        _callBack(sender.selected);
    }
}










@end
