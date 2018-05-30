//
//  ChannelModel.h
//  MyChannel
//
//  Created by Apple on 2018/5/29.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "CButton.h"
@class CButton;
@interface ChannelModel : NSObject

@property (nonatomic , copy)NSString *name;
@property (nonatomic , assign)BOOL isMyChannel;
@property (nonatomic , assign)CGRect frame;
@property (nonatomic , assign)int tag;
@property (nonatomic , assign)BOOL hideDeleBtn;
@property (nonatomic , weak)CButton *btn;

@end
