//
//  CButton.h
//  MyChannel
//
//  Created by Apple on 2018/5/29.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ChannelModel.h"
@class  CButton;
typedef void(^MyChannelHandle)(CButton*);
typedef void(^RecommondHandle)(CButton*);

typedef void(^BeginBtn)(CButton* btn);
typedef void(^ChangeBtn)(CButton* btn,UIGestureRecognizer *ges);
typedef void(^EndBtn)(CButton* btn);


#import "ChannelModel.h"
@interface CButton : UIButton

@property (nonatomic , strong)ChannelModel *model;
@property (nonatomic , weak)UIImageView *deleImageView;

@property (nonatomic , copy)MyChannelHandle myChannelHandle;
@property (nonatomic , copy)RecommondHandle recommondHandle;
@property (nonatomic , copy)BeginBtn beginBtn;
@property (nonatomic , copy)ChangeBtn changeBtn;
@property (nonatomic , copy)EndBtn endBtn;
-(void)reloadData;
@end
