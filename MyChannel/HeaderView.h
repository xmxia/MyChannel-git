//
//  HeaderView.h
//  MyChannel
//
//  Created by Apple on 2018/5/29.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CButton.h"

typedef void(^callBack)(BOOL);

@interface HeaderView : UIView
@property (strong, nonatomic) IBOutlet UILabel *channelLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;

@property (nonatomic,copy)callBack callBack;
-(instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle needEditBtn:(BOOL)needEditBtn;
    

@end
